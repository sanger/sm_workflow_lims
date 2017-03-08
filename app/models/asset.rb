require 'active_record'
require './lib/state_scoping'
require './lib/client_side_validations'

class Asset < ActiveRecord::Base

  extend StateScoping

  belongs_to :asset_type
  belongs_to :workflow
  belongs_to :pipeline_destination
  belongs_to :cost_code
  belongs_to :batch
  belongs_to :comment

  has_many :events, dependent: :destroy

  after_destroy :remove_comment, :if => :comment

  include ClientSideValidations
  validate_with_regexp :study, :with => /^\w+$/

  def remove_comment
    comment.destroy
  end

  def self.with_identifier(search_string)
    search_string.nil? ? all : where(identifier:search_string)
  end

  def self.in_state(state)
    if state.present?
      Asset.where("current_state = ?", state)
    else
      Asset.all
    end
  end

  before_create :set_begun_at

  def set_begun_at
    self.begun_at ||= self.created_at
  end
  private :set_begun_at

  validates_presence_of :workflow, :batch, :identifier, :asset_type

  delegate :identifier_type, to: :asset_type

  scope :latest_first,    -> { order('begun_at DESC') }

  default_scope { includes(:workflow,:asset_type,:comment,:batch) }

  def reportable?
    workflow.reportable?
  end

  def completed?
    completed_at.present?
  end

  def completed_at
    @completed_at || events.completed.first.try(:created_at)
  end

  def age
    # DateTime#-(DateTime) Returns the difference in days as a rational (in Ruby 2.2.2)
    DateTime.now - begun_at.to_datetime
  end

  def time_without_completion
    return ((completed_at - begun_at) / 86400).floor if completed?
    age
  end

  def next_state
    workflow.next_step_name(current_state)
  end

  def move_to_next_state
    ActiveRecord::Base.transaction do
      events.create!(from: current_state, to: next_state)
      update_attributes!(current_state: next_state)
    end
  end


  class AssetAction
    attr_reader :time, :assets, :state, :asset_state

    def self.create!(*args)
      self.new(*args).tap {|action| action.do! }
    end

    def initialize(time:,assets:)
      @time = time
      @assets = assets
      @asset_state = assets.first.current_state
      @state = 'incomplete'
    end

    private

    def done?
      state == 'success'
    end

    def identifiers
      @identifiers = assets.map(&:identifier)
    end
  end

  class Updater < AssetAction

    def do!
      ActiveRecord::Base.transaction do
        assets.each {|a| a.move_to_next_state }
        @state = 'success'
      end
      true
    end

    def message
      done? ? "#{asset_state.humanize} step is done for #{identifiers.to_sentence}" :
              "#{asset_state.humanize} step is not done for requested assets."
    end

    def redirect_state; asset_state; end
  end

end
