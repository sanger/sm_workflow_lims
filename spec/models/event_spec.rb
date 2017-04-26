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

  it 'should find events with particular last state' do
    report_required = create :state, name: 'report_required'
    in_progress_event_first_asset = Event.create!(state: in_progress, asset: asset)
    in_progress_event_second_asset = Event.create!(state: in_progress, asset: (create :asset))
    report_required_event_first_asset = Event.create!(state: report_required, asset: asset)
    expect(Event.with_last_state(in_progress).to_a).to eq [in_progress_event_second_asset]
    expect(Event.with_last_state(report_required).to_a).to eq [report_required_event_first_asset]

  end


end