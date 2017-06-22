
module StateMachine

  extend ActiveSupport::Concern

  included do
    delegate :in_progress?, :volume_check?, :quant?, :report_required?, :reported?, to: :current_state
  end

  # this method moves asset to the next state (like 'quant', 'report_required')
  def next(state)
    if !completed? || reportable?
      create_event(state)
    end
  end

  # this method marks asset as 'completed' or 'reported'
  def finalize(state)
    return unless state.present?
    create_event(state)
  end

  def create_event(state)
    events.create! state: state
  end

  def current_state
    events.last.state.name.inquiry
  end

end
