require 'active_record'

class Workflow < ActiveRecord::Base

  has_many :assets

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :turn_around_days, :greater_than_or_equal_to => 0, :allow_nil => true, :only_integer => true

  class Creator

    attr_reader :name, :has_comment, :reportable, :turn_around_days, :multi_team_quant_essential

    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(name:,has_comment:,reportable:,multi_team_quant_essential:,turn_around_days:nil)
      @name = name
      @has_comment = has_comment
      @reportable = reportable
      @multi_team_quant_essential = multi_team_quant_essential
      @turn_around_days = turn_around_days
    end

    def do!
      ActiveRecord::Base.transaction do
        Workflow.new(name: name, has_comment: has_comment, reportable: reportable, multi_team_quant_essential: multi_team_quant_essential, turn_around_days: turn_around_days).save!
      end
    end

  end

  class Updater

    attr_reader :name, :has_comment, :reportable, :turn_around_days, :workflow, :turn_around_days, :multi_team_quant_essential

    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(workflow:, name:, has_comment:, reportable:, multi_team_quant_essential:, turn_around_days:nil)
      @workflow = workflow
      @name = name
      @has_comment = has_comment
      @reportable = reportable
      @turn_around_days = turn_around_days
      @multi_team_quant_essential = multi_team_quant_essential
    end

    def do!
      ActiveRecord::Base.transaction do
        workflow.update_attributes!(name:name, has_comment: has_comment, reportable: reportable, turn_around_days: turn_around_days, multi_team_quant_essential: multi_team_quant_essential)
      end
    end
  end
end
