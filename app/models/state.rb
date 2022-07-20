class State < ApplicationRecord
  has_many :events
  has_many :workflows

  validates :name, presence: true
  validates :name, uniqueness: true
end
