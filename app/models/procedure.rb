class Procedure < ActiveRecord::Base

  belongs_to :team
  belongs_to :state
  belongs_to :finishing_state, class_name: 'State'

  validates :order, presence: true, uniqueness: {scope: :team}

  def state_name=(state_name)
    self.state = State.find_by(name: state_name)
  end

  def finishing_state_name=(finishing_state_name)
    self.finishing_state = State.find_by(name: finishing_state_name)
  end

end
