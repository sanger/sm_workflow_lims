require 'rails_helper'

describe State do
  let(:state) { State.new }

  it 'has name' do
    expect(state.valid?).to be false
    state.name = 'name'
    expect(state.valid?).to be true
  end
end
