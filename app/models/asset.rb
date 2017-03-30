require 'active_record'
require './app/models/concerns/state_machine'
require './lib/client_side_validations'

class Asset < ActiveRecord::Base

  include StateMachine

  belongs_to :asset_type
  belongs_to :workflow
  belongs_to :pipeline_destination
  belongs_to :cost_code
  belongs_to :batch
  belongs_to :comment

  has_many :events, dependent: :destroy

  after_destroy :remove_comment, :if => :comment

  after_create :create_initial_event

  include ClientSideValidations
  validate_with_regexp :study, :with => /^\w+$/

  def remove_comment
    comment.destroy
  end

  def self.in_state(state)
    if state.present?
      joins(:events)
        .where(events: {id: Event.latest_per_asset, state: state})
        .includes(events: :state)
    else
      all
    end
  end

  def self.with_identifier(search_string)
    search_string.nil? ? all : where(identifier: search_string)
  end

  before_create :set_begun_at

  def set_begun_at
    self.begun_at ||= self.created_at
  end
  private :set_begun_at

  validates_presence_of :workflow, :batch, :identifier, :asset_type

  delegate :identifier_type, to: :asset_type

  scope :in_progress,     -> { where(completed_at: nil) }
  scope :completed,       -> { where.not(completed_at: nil) }
  scope :reportable,      -> { where(workflows:{reportable:true}) }
  scope :report_required, -> { reportable.completed.where(reported_at:nil) }
  scope :reported,        -> { reportable.completed.where.not(reported_at:nil) }
  scope :latest_first,    -> { order('begun_at DESC') }

  default_scope { includes(:workflow,:asset_type,:comment,:batch) }

  def reportable?
    workflow.reportable?
  end

  def completed?
    completed_at.present?
  end

  def completed_at
    super || events.detect { |event| event.state.name == 'completed' }.try(:created_at)
  end

  def age
    # DateTime#-(DateTime) Returns the difference in days as a rational (in Ruby 2.2.2)
    DateTime.now - begun_at.to_datetime
  end

  def time_without_completion
    return ((completed_at - begun_at) / 86400).floor if completed?
    age
  end

  def create_initial_event
    events.create!(state: workflow.initial_state, created_at: begun_at)
  end

  class AssetAction
    attr_reader :action, :assets, :state, :asset_state

    def self.create!(*args)
      self.new(*args).tap {|action| action.do! }
    end

    def initialize(action:,assets:)
      @action = action
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
        assets.each { |a| a.perform_action(action) }
        @state = 'success'
      end
      true
    end

    def message
      done? ? "#{asset_state.humanize} is done for #{identifiers.to_sentence}" :
              "#{asset_state.humanize} has not been finished for requested assets."
    end

    def redirect_state; asset_state; end
  end

end
