require 'active_record'

class CostCode < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  has_many :assets

  class Creator
    def self.create!(*args)
      self.new(*args).do!
    end

    def initialize(name)
      @name = name
    end

    def do!
      ActiveRecord::Base.transaction do
        CostCode.new(:name => @name).save!
      end
    end
  end

end
