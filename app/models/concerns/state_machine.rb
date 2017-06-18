
module StateMachine

  extend ActiveSupport::Concern

  included do
    delegate :in_progress?, :volume_check?, :quant?, :report_required?, :reported?, to: :current_state
  end

  # this method moves asset to the next state (like 'quant', 'report_required')
  def move_to_next(state)
    if !completed? || reportable?
      move_to(state)
    end
  end

  # this method marks asset as 'completed' or 'reported'
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
