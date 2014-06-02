require 'spec_helper'
require './app/models/asset'

describe Asset::Completer do

        #   Asset::Completer.should_receive(:create!).with(
        #   assets: [mock_asset],
        #   time: time
        # )
  context "with an array of assets" do

    let(:time)   { DateTime.parse('01-02-2012 13:15') }
    let(:assets) { [asset1,asset2]}
    let(:asset1) { double(:asset1) }
    let(:asset2) { double(:asset2) }

    it "should flag the assets as completed" do

      asset1.should_receive(:update_attributes!).with(completed_at:time)
      asset2.should_receive(:update_attributes!).with(completed_at:time)
      Asset::Completer.create!(assets:[asset1,asset2],time:time)
    end

  end

end
