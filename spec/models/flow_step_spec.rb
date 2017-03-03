require 'spec_helper'
require './app/models/step'
require './app/models/flow'
require './app/models/flow_step'

describe FlowStep do

  let!(:step) { create :step }
  let!(:flow) { create :flow }
  let(:flow_step) { FlowStep.new(step_id: step, flow_id: flow, position: 1) }

  it 'can have a position' do
    expect(flow_step.position).to eq 1
  end

end