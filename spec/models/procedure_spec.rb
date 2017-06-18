require 'rails_helper'

describe Procedure do

  it 'should be able to crate one using state_name and finishing_state_name' do
    state1 = create :state, name: 'first'
    state2 = create :state, name: 'last'
    procedure = Procedure.new(state_name: 'first', finishing_state_name: 'last', order: 1)
    expect(procedure.state).to eq state1
    expect(procedure.finishing_state).to eq state2
  end

end