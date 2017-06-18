class Team < ActiveRecord::Base
  has_many :procedures, dependent: :destroy
  accepts_nested_attributes_for :procedures

  has_many :states, through: :procedures
  has_many :workfows

  validates :name, presence: true

  attr_writer :states_names

  def states_names=(stages_names)
    states_names.each do |state_name|
      states << State.find_by(name: state_name)
    end
  end

  def first_state
    states.first
  end

  def humanized_name
    name.humanize
  end

end

