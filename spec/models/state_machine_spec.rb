require 'spec_helper'
require './app/models/asset'
require './app/models/event'

describe Asset do

  let!(:state1) { create :state, name: 'in_progress' }
  let!(:state2) { create :state, name: 'completed' }
  let!(:state3) { create :state, name: 'report_required' }
  let(:asset) { create :asset }
  let(:reportable_asset) { create :asset, workflow: (create :workflow_with_report) }

  it 'should know the current state' do
    expect(asset.in_progress?).to be_true
    expect(asset.reported?).to be_false
  end

  it 'should create the right events' do
    asset.complete
    expect(asset.events.count).to eq 1
    expect(asset.completed?).to be_true
    reportable_asset.complete
    expect(reportable_asset.events.count).to eq 2
    expect(reportable_asset.report_required?).to be_true
  end

end