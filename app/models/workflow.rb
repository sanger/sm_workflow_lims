require 'active_record'

class Workflow < ActiveRecord::Base

  has_many :assets

  validates_presence_of :name
  validates_uniqueness_of :name
  validates_numericality_of :turn_around_days, :greater_than_or_equal_to => 0, :allow_nil => true

  class Creator
    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(name, hasComment, reportable)
      hasComment ||= false
      reportable ||= false

      @name = name
      @hasComment = hasComment
      @reportable = reportable
    end

    def do!
      ActiveRecord::Base.transaction do
        Workflow.new(:name => @name, :has_comment => @hasComment, :reportable => @reportable).save!
      end
    end
  end
end
