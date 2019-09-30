class State < ActiveRecord::Base
  has_many :events
  has_many :workflows

  validates_presence_of :name
  validates_uniqueness_of :name
end
