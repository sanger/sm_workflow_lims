class Asset < ActiveRecord::Base

  include StateMachine
  include ClientSideValidations

  belongs_to :asset_type
  belongs_to :workflow
  belongs_to :pipeline_destination
  belongs_to :cost_code
  belongs_to :batch
  belongs_to :comment
  has_many :events, dependent: :destroy

  before_create :set_begun_at
  after_create :create_initial_event
  after_destroy :remove_comment, :if => :comment

  validate_with_regexp :study, :with => /^\w+$/
  validates_presence_of :workflow, :batch, :identifier, :asset_type

  delegate :identifier_type, to: :asset_type
  default_scope { includes(:workflow,:asset_type,:comment,:batch, :pipeline_destination, events: :state) }

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
      where("identifier = :search_string or batch_id = :search_string", search_string: search_string)
    else
      all
    end
  end

  # returns an array of hashes
  def self.generate_report_data(start_date, end_date, workflow)
    where(workflow: workflow)
      .joins(:events)
      .merge(Event.completed_between(start_date, end_date))
      .joins("LEFT JOIN cost_codes ON assets.cost_code_id = cost_codes.id")
      .group("study")
      .group("project")
      .group("cost_codes.name")
      .count
      .map do |key, value|
        { study: key[0], project: key[1], cost_code_name: key[2], assets_count: value }.with_indifferent_access
      end
  end

  def reportable?
    workflow.reportable?
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
    return ((completed_at - begun_at) / 86400).floor if completed?
    age
  end

  private

  def set_begun_at
    self.begun_at ||= self.created_at
  end

  def create_initial_event
    events.create!(state: workflow.first_state, created_at: begun_at)
  end

  def remove_comment
    comment.destroy
  end

end
