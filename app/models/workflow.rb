class Workflow < ApplicationRecord
  has_many :assets
  belongs_to :initial_state, class_name: 'State'

  validates :name, presence: true
  validates :name, uniqueness: true
  validates :turn_around_days, numericality: { greater_than_or_equal_to: 0, allow_nil: true, only_integer: true }

  attr_reader :initial_state_name

  def initial_state_name=(initial_state_name)
    self.initial_state = State.find_by(name: initial_state_name)
  end
end
