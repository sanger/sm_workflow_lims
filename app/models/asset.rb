require './lib/client_side_validations'

class Asset < ApplicationRecord
  include StateMachine

  belongs_to :asset_type
  belongs_to :workflow
  belongs_to :pipeline_destination, optional: true
  belongs_to :cost_code, optional: true
  belongs_to :batch
  belongs_to :comment, optional: true
  has_many :events, dependent: :destroy

  before_create :set_begun_at
  after_create :create_initial_event
  after_destroy :remove_comment, if: :comment

  include ClientSideValidations
  validate_with_regexp :study, with: /^\w+$/
  validates :identifier, presence: true

  delegate :identifier_type, to: :asset_type
  default_scope { includes(:workflow, :asset_type, :comment, :batch, :pipeline_destination, events: :state) }

  def remove_comment
    comment.destroy
  end

  def self.in_state(state)
    if state.present?
      joins(:events)
        .merge(Event.with_last_state(state))
        .order(batch_id: :asc)
    else
      all
    end
  end

  def self.with_identifier(search_string)
    if search_string.present?
      where('identifier = :search_string or batch_id = :search_string', search_string: search_string)
    else
      all
    end
  end

  def set_begun_at
    self.begun_at ||= created_at
  end
  private :set_begun_at

  # returns an array of hashes
  def self.generate_report_data(start_date, end_date, workflow)
    where(workflow: workflow)
      .joins(:events)
      .merge(Event.completed_between(start_date, end_date))
      .joins('LEFT JOIN cost_codes ON assets.cost_code_id = cost_codes.id')
      .group('study')
      .group('project')
      .group('cost_codes.name')
      .count
      .map do |key, value|
        { study: key[0], project: key[1], cost_code_name: key[2], assets_count: value }.with_indifferent_access
      end
  end

  delegate :reportable?, to: :workflow

  def qcable?
    workflow.qc_flow?
  end

  def completed?
    completed_at.present?
  end

  def completed_at
    events.detect { |event| event.state.name == 'completed' }.try(:created_at)
  end

  def age
    # DateTime#-(DateTime) Returns the difference in days as a rational (in Ruby 2.2.2)
    DateTime.now - begun_at.to_datetime
  end

  def time_without_completion
    return ((completed_at - begun_at) / 86_400).floor if completed?

    age
  end

  def create_initial_event
    events.create!(state: workflow.initial_state, created_at: begun_at)
  end

  class AssetAction
    attr_reader :action, :assets, :flash_status, :asset_state

    def self.create!(*args)
      new(*args).tap { |action| action.do! }
    end

    def initialize(action:, assets:)
      @action = action
      @assets = assets
      @asset_state = assets.first.current_state
      @flash_status = :alert
    end

    private

    def done?
      flash_status == :notice
    end

    def identifiers
      @identifiers = assets.map(&:identifier)
    end
  end

  class Updater < AssetAction
    def do!
      ActiveRecord::Base.transaction do
        assets.each { |a| a.perform_action(action) }
        @flash_status = :notice
      end
      true
    end

    def message
      if done?
        "#{asset_state.humanize} is done for #{identifiers.sort.to_sentence}"
      else
        "#{asset_state.humanize} has not been finished for requested assets."
      end
    end

    def redirect_state
      asset_state
    end
  end
end
