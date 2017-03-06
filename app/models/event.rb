require 'active_record'

class Event < ActiveRecord::Base
  belongs_to :asset

  validates_presence_of :from, :to

end