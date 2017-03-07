require 'spec_helper'
require './app/models/step'
require './app/models/flow'
require './app/models/flow_step'

describe Flow do

  let(:flow) { Flow.new }

  it 'should not be valid without a name' do
    expect(flow.valid?).to be false
    flow.name = 'test'
    expect(flow.valid?).to be true
    expect(flow.save).to be true
  end

  it 'can have many steps' do
    flow.name = 'test'
    flow.steps << (create :step)
    flow.steps << (create :step)
    flow.save
    expect(flow.steps.count).to eq 2
  end

  it 'steps should know its initial step name' do
    flow = create :flow_with_steps
    first_step = create :flow_step, position: 1, step: (create :step, name: 'initial')
    flow.flow_steps << first_step
    expect(flow.steps.count).to eq 4
    expect(flow.initial_step).to eq first_step
    expect(flow.initial_step_name).to eq 'initial'
  end

  it 'should know the next step' do
    flow = create :flow_with_steps
    step3 = flow.flow_steps.find_by(position: 3)
    step4 = flow.flow_steps.find_by(position: 4)
    expect(flow.next_step(step3)).to eq step4
    new_step = create :flow_step, position: 7
    flow.flow_steps << new_step
    expect(flow.next_step(step4)).to eq new_step
  end

  it 'should know the next step name based on current step name' do
    flow = create :flow_with_steps
    step3_name = flow.flow_steps.find_by(position: 3).name
    step4 = flow.flow_steps.find_by(position: 4)
    expect(flow.next_step_name(step3_name)).to eq step4.name
    new_step = create :flow_step, position: 7
    flow.flow_steps << new_step
    expect(flow.next_step_name(step4.name)).to eq new_step.name
  end

  it 'should add steps' do
    step1 = create :step, name: 'first'
    step3 = create :step, name: 'last'
    step2 = create :step, name: 'middle'
    flow = Flow.new(name: 'test', steps_names: ['first', 'middle', 'last'])
    expect(flow.steps.count).to eq 3
    expect(flow.initial_step_name).to eq 'first'
    expect(flow.next_step_name('first')).to eq 'middle'
    expect(flow.next_step_name('middle')).to eq 'last'
  end

end