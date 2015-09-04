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
    scope_for(state)
  end

  before_create :set_begun_at

  def set_begun_at
    self.begun_at ||= self.created_at
  end
  private :set_begun_at

  validates_presence_of :workflow, :batch, :identifier, :asset_type

  delegate :identifier_type, :to => :asset_type

  scope :in_progress,     -> { where(completed_at: nil) }
  scope :completed,       -> { where.not(completed_at: nil) }
  scope :reportable,      -> { where(workflows:{reportable:true}) }
  scope :report_required, -> { reportable.completed.where(reported_at:nil) }
  scope :latest_first,    -> { order('begun_at DESC') }

  add_state('all',             :all)
  add_state('in_progress',     :in_progress)
  add_state('report_required', :report_required)

  default_scope { includes(:workflow,:asset_type,:comment,:batch) }

  def reportable?
    workflow.reportable?
  end

  def completed?
    completed_at.present?
  end

  def age
    # DateTime#-(DateTime) Returns the difference in days as a rational (in Ruby 2.2.2)
    DateTime.now - begun_at.to_datetime
  end

  class AssetAction
    attr_reader :time, :assets, :state

    def self.create!(*args)
      self.new(*args).tap {|action| action.do! }
    end

    def initialize(time:,assets:)
      @time = time
      @assets = assets
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

  class Completer < AssetAction

    def do!
      ActiveRecord::Base.transaction do
        assets.each {|a| a.update_attributes!(completed_at:time) }
        @state = 'success'
      end
      true
    end

    def message
      done? ? "#{identifiers.to_sentence} #{identifiers.many? ? 'were' : 'was'} marked as completed." :
              'Assets have not been completed.'
    end

    def redirect_state; 'in_progress'; end

  end

  class Reporter < AssetAction

    def do!
      return false unless valid?
      ActiveRecord::Base.transaction do
        assets.each {|a| a.update_attributes!(reported_at:time) }
        @state = 'success'
      end
      true
    end

    def valid?
      assets.each do |asset|
        asset.reportable? || log_error("#{asset.identifier} is in #{asset.workflow.name}, which does not need a report.")
        asset.completed?  || log_error("#{asset.identifier} can not be reported on before it is completed.")
      end
      errors.empty?
    end

    def message
      return errors.join("\n") if errors.present?
      done? ? "#{identifiers.to_sentence} #{identifiers.many? ? 'were' : 'was'} marked as reported." :
              'Assets have not been reported.'
    end

    def redirect_state; 'report_required'; end

    private

    def errors
      @errors ||= []
    end

    def log_error(message)
      @state = 'danger'
      errors << message
    end

  end
end
