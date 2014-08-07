module StateScoping
  def add_state(state,scope)
    states[state] = scope
  end

  def states
    @states ||= Hash.new(:none)
  end

  def scope_for(state)
    send(states[state])
  end

  def valid_state(state)
    states[:state] != :none
  end
end
