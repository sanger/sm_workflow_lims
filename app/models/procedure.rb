class Procedure < ActiveRecord::Base

  # Procedure is a joining table between teams and states
  # Process is a better name but it is reserved by Rails
  # State is a state at which asset stays during the procedure (like 'volume_check', 'quant')
  # Finishing state is a state at which assets leaves the procedure (like 'completed', 'reported')
  # It also has an order so that team could easily find the next one

  belongs_to :team
  belongs_to :state
  belongs_to :final_state, class_name: 'State'

  validates :order, presence: true, uniqueness: {scope: :team}

  def state_name=(state_name)
    self.state = State.find_by(name: state_name)
  end

  def final_state_name=(final_state_name)
    self.final_state = State.find_by(name: final_state_name)
  end

end
