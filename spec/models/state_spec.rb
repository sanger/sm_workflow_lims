require 'spec_helper'
require './app/models/state'

describe State do

  let(:state) { State.new }

  it 'should have name' do
    expect(state.valid?).to be false
    state.name = 'name'
    expect(state.valid?).to be true
  end


end