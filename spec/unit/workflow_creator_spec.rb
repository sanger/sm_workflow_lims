require 'spec_helper'
require './app/models/workflow'

describe Workflow::Creator do
  it 'can choose the correct flow' do
    arguments = { has_comment: true, reportable: true }
    standard_flow = create :flow, name: 'standard'
    multi_team_flow = create :flow, name: 'multi_team_quant_essential'
    creator = Workflow::Creator.create!(arguments.merge(name: 'new_workflow', multi_team_quant_essential: false))
    expect(Workflow.last.flow).to eq standard_flow
    creator = Workflow::Creator.create!(arguments.merge(name: 'new_workflow2', multi_team_quant_essential: true))
    expect(Workflow.last.flow).to eq multi_team_flow
  end
end