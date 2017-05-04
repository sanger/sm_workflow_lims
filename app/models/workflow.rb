class Workflow < ActiveRecord::Base

  has_many :assets
  belongs_to :initial_state, class_name: 'State'

  validates_presence_of :name, :initial_state
  validates_uniqueness_of :name
  validates_numericality_of :turn_around_days, :greater_than_or_equal_to => 0, :allow_nil => true, :only_integer => true

  attr_accessor :initial_state_name

  def initial_state_name=(initial_state_name)
    self.initial_state = State.find_by(name: initial_state_name)
  end

  def multi_team_quant_essential
    initial_state.multi_team_quant_essential?
  end

end
