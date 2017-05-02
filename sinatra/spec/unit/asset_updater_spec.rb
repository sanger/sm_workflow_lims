require 'spec_helper'
require './app/models/asset'

describe Asset::Updater do

  context "with an array of assets" do

    let(:time)   { DateTime.parse('01-02-2012 13:15') }
    let(:assets) { [asset1,asset2]}
    let(:asset1) { double(:asset1,identifier:'a', current_state:'in_progress') }
    let(:asset2) { double(:asset2,identifier:'b', current_state:'in_progress') }
    let(:message) {"In progress is done for a and b"}

    it "should flag the assets as completed" do
      asset1.should_receive(:current_state)
      asset1.should_receive(:perform_action).with('complete')
      asset2.should_receive(:perform_action).with('complete')
      Asset::Updater.create!(assets:[asset1,asset2], action:'complete')
    end

    it "should have a success state if successful" do
      asset1.should_receive(:current_state)
      asset1.should_receive(:perform_action).with('report')
      asset2.should_receive(:perform_action).with('report')
      Asset::Updater.create!(assets:[asset1,asset2], action: 'report').state.should eq('success')
    end

    it "should summarise updated assets" do
      asset1.should_receive(:current_state)
      asset1.should_receive(:perform_action).with('complete')
      asset2.should_receive(:perform_action).with('complete')
      Asset::Updater.create!(assets:[asset1,asset2], action: 'complete').message.should eq(message)
    end

  end

end