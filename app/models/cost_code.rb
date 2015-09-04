require 'active_record'

require './lib/client_side_validations'

class CostCode < ActiveRecord::Base

  validates_presence_of :name
  validates_uniqueness_of :name

  include ClientSideValidations

  validate_with_regexp :name, :with => /^[A-Za-z]\d+$/, :allow_blank => true,
    :error_msg => "The cost code should should be one letter followed by digits"

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
