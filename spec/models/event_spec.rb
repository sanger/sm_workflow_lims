require 'spec_helper'
require './app/models/event'

describe Event do

  let(:event) { Event.new }
  let(:asset) { create :asset }
  let!(:in_progress) { create :state, name: 'in_progress'}

  it 'should have name' do
    expect(event.valid?).to be false
    event.state = 'in_progress'
    event.asset = asset
    expect(event.valid?).to be true
  end

  it 'should know the date for particular state' do
    in_progress_event = Event.create!(state: in_progress, asset: asset)
    expect(Event.date('reported')).to be_false
    expect(Event.date('in_progress')).to be_true
  end


end