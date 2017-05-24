require 'rails_helper'

describe Event do

  let(:event) { Event.new }
  let(:asset) { create :asset }
  let!(:in_progress) { create :state, name: 'in_progress'}
  let!(:completed) { create :state, name: 'completed'}

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

  it 'should find events with completed state for requested period' do
    new_event = create :event, state: completed
    Timecop.freeze(Time.local(2017, 3, 7))
    old_in_progress_events = create_list(:event, 3, state: in_progress)
    old_completed_events = create_list(:event, 2, state: completed)
    expect(Event.completed_between(Date.today-1, Date.today+1)).to eq old_completed_events
  end

  after do
    Timecop.return
  end

end