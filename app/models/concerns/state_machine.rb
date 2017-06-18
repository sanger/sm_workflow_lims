
module StateMachine

  extend ActiveSupport::Concern

  included do
    delegate :in_progress?, :volume_check?, :quant?, :report_required?, :reported?, to: :current_state
  end

  # this method is used to move asset to the next state
  def move_to_next(state)
    if !completed? || reportable?
      move_to(state)
    end
  end

  # this method is used to mark asset as 'completed' or 'reported'
  def update(state)
    return unless state.present?
    move_to(state)
  end

  def move_to(state)
    events.create! state: state
  end

  def current_state
    events.last.state.name.inquiry
  end

end
