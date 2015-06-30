require 'active_record'

class Workflow < ActiveRecord::Base

  has_many :assets

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :turn_around_days, :greater_than_or_equal_to => 0, :allow_nil => true, :only_integer => true

  class Creator

    attr_reader :name, :has_comment, :reportable, :turn_around_days

    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(name:,has_comment:false,reportable:false,turn_around_days:nil)

      @name = name
      @has_comment = has_comment
      @reportable = reportable
    end

    def do!
      ActiveRecord::Base.transaction do
        Workflow.new(:name => @name, :has_comment => @has_comment, :reportable => @reportable).save!
      end
    end
  end
end
