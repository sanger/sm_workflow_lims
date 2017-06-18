class State < ActiveRecord::Base
  has_many :events
  has_many :workflows

  has_many :procedures
  has_many :teams, through: :procedures

  validates :name, presence: true, uniqueness: true

end
