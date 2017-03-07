# require 'spec_helper'
# require './app/models/asset'

# describe Asset::Completer do

  # context "with an array of assets" do

  #   let(:time)   { DateTime.parse('01-02-2012 13:15') }
  #   let(:assets) { [asset1,asset2]}
  #   let(:asset1) { double(:asset1,identifier:'a') }
  #   let(:asset2) { double(:asset2,identifier:'b') }
  #   let(:message) {"a and b were marked as completed."}

  #   it "should flag the assets as completed" do
  #     asset1.should_receive(:update_attributes!).with(completed_at:time)
  #     asset2.should_receive(:update_attributes!).with(completed_at:time)
  #     Asset::Completer.create!(assets:[asset1,asset2],time:time)
  #   end

  #   it "should have a success state if successful" do
  #     asset1.should_receive(:update_attributes!).with(completed_at:time)
  #     asset2.should_receive(:update_attributes!).with(completed_at:time)
  #     Asset::Completer.create!(assets:[asset1,asset2],time:time).state.should eq('success')
  #   end

  #   it "should summarise updated assets" do
  #     asset1.should_receive(:update_attributes!).with(completed_at:time)
  #     asset2.should_receive(:update_attributes!).with(completed_at:time)
  #     Asset::Completer.create!(assets:[asset1,asset2],time:time).message.should eq(message)
  #   end

  # end

# end
