require 'spec_helper'
require './app/models/step'
require './app/models/flow'
require './app/models/flow_step'

describe Step do

  let(:step) { Step.new }

  it 'should not be valid without a name' do
    expect(step.valid?).to be false
    step.name = 'test'
    expect(step.valid?).to be true
    expect(step.save).to be true
  end

  it 'can have many flows' do
    step.name = 'test'
    step.flows << (create :flow)
    step.save
    expect(step.flows.count).to eq 1
  end

end