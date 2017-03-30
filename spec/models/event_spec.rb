require 'spec_helper'
require './app/models/event'

describe Event do

  let(:event) { Event.new }
  let(:asset) { create :asset }
  let!(:in_progress) { create :state, name: 'in_progress'}

  it 'should have name' do
    expect(event.valid?).to be false
    event.state_name = 'in_progress'
    event.asset = asset
    expect(event.valid?).to be true
  end

  it 'should know ids for latest events per asset' do
    report_required = create :state, name: 'report_required'
    in_progress_event_first_asset = Event.create!(state: in_progress, asset: asset)
    report_required_event_first_asset = Event.create!(state: report_required, asset: asset)
    in_progress_event_second_asset = Event.create!(state: report_required, asset: (create :asset))
    expect(Event.latest_per_asset).to eq [report_required_event_first_asset.id, in_progress_event_second_asset.id]
  end


end