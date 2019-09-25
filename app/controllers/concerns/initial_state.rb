module InitialState
  extend ActiveSupport::Concern

  def initial_state(qc_flow, cherrypick_flow)
    return 'cherrypick' if cherrypick_flow

    if qc_flow
      'volume_check'
    else
      'in_progress'
    end
  end
end
