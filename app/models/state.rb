class State < ActiveRecord::Base
  has_many :events
  has_many :workflows

  validates :name, presence: true
  validates :name, uniqueness: true
end
