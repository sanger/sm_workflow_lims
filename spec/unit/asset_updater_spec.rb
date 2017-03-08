require 'spec_helper'
require './app/models/asset'

describe Asset::Updater do

  context "with an array of assets" do

    let(:time)   { DateTime.parse('01-02-2012 13:15') }
    let(:assets) { [asset1,asset2]}
    let(:asset1) { double(:asset1,identifier:'a', current_state: 'in_progress') }
    let(:asset2) { double(:asset2,identifier:'b') }
    let(:message) {"In progress step is done for a and b"}

    it "should flag the assets as completed" do
      asset1.should_receive(:move_to_next_state)
      asset1.should_receive(:current_state)
      asset2.should_receive(:move_to_next_state)
      Asset::Updater.create!(assets:[asset1,asset2],time:time)
    end

    it "should have a success state if successful" do
      asset1.should_receive(:move_to_next_state)
      asset1.should_receive(:current_state)
      asset2.should_receive(:move_to_next_state)
      Asset::Updater.create!(assets:[asset1,asset2],time:time).state.should eq('success')
    end

    it "should summarise updated assets" do
      asset1.should_receive(:move_to_next_state)
      asset1.should_receive(:current_state)
      asset2.should_receive(:move_to_next_state)
      Asset::Updater.create!(assets:[asset1,asset2],time:time).message.should eq(message)
    end

  end

end