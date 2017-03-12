require 'active_record'

class State < ActiveRecord::Base
  has_many :events

  validates_presence_of :name
  validates_uniqueness_of :name

end