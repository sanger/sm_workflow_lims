require 'active_record'

class Workflow < ActiveRecord::Base

  has_many :assets
  belongs_to :flow

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :turn_around_days, :greater_than_or_equal_to => 0, :allow_nil => true, :only_integer => true

  delegate :initial_step_name, to: :flow
  delegate :next_step_name, to: :flow

  def flow=(flow)
    flow = Flow.find_by(name: flow) if flow.is_a? String
    super
  end

  class Creator

    attr_reader :name, :has_comment, :reportable, :turn_around_days, :flow

    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(name:,has_comment:,reportable:,multi_team_quant_essential:,turn_around_days:nil)
      @name = name
      @has_comment = has_comment
      @reportable = reportable
      @flow = find_flow(multi_team_quant_essential)
    end

    def do!
      ActiveRecord::Base.transaction do
        Workflow.new(name: name, has_comment: has_comment, reportable: reportable, flow: flow).save!
      end
    end

    #to be changed
    def find_flow(multi_team_quant_essential)
      flow_name = multi_team_quant_essential ? 'multi_team_quant_essential' : 'standard'
      Flow.find_by(name: flow_name)
    end
  end

  class Updater

    attr_reader :name, :has_comment, :reportable, :turn_around_days, :workflow, :turn_around_days

    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(workflow:,name:,has_comment:,reportable:,turn_around_days:nil)
      @workflow = workflow
      @name = name
      @has_comment = has_comment
      @reportable = reportable
      @turn_around_days = turn_around_days
    end

    def do!
      ActiveRecord::Base.transaction do
        workflow.update_attributes!(name:name, has_comment: has_comment, reportable: reportable, turn_around_days: turn_around_days)
      end
    end
  end
end
