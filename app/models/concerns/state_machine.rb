# require './app/models/state'

module StateMachine

  extend ActiveSupport::Concern

  included do
    delegate :in_progress?, :volume_check?, :quant?, :report_required?, :reported?, to: :current_state
  end

  StateMachineError = Class.new(StandardError)

  VALID_ACTIONS = ['check_volume', 'complete', 'report']

  def perform_action(action)
    if VALID_ACTIONS.include? action
      send(action)
    else
      raise StateMachineError, "#{action} is not a recognised action"
    end
  end

  def complete
    events.create! state_name: 'completed' if (in_progress? || quant?)
    events.create! state_name: 'report_required' if reportable?
  end

  def check_volume
    events.create! state_name: 'quant' if volume_check?
  end

  def report
    events.create! state_name: 'reported' if report_required?
  end

  def current_state
    events.last.state.name.inquiry
  end

end

