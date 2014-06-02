require 'spec_helper'
require './app/controllers/assets_controller'

describe AssetsController do

  let(:mock_asset) {
    double('asset',identifier:'fake',asset_type:double('asset_type',name:'type'))
  }

  context "index" do

    # S27: So can delay

    let(:request) { AssetsController.new(params).get_index }
    let(:params)  { {} }

    it "should look up all in progress assets" do
      Asset.should_receive(:in_progress).and_return([mock_asset])
      request
    end

    it "should return an assets index presenter" do
      Asset.stub(:in_progress).and_return([mock_asset])
      Presenter::AssetPresenter::Index.should_receive(:new).and_return('presenter')
      request.should eq('presenter')
    end

    it "should pass a nil search parameter and assets to the presenter" do
      Asset.stub(:in_progress).and_return([mock_asset])
      Presenter::AssetPresenter::Index.should_receive(:new).with([mock_asset],nil)
      request
    end

  end

  context "index with parameters" do

    # We'll shift to the join

    let(:request) { AssetsController.new(params).get_index }
    let(:params)  { {:identifier=>'Test'} }

    it "should look up all assets with an identifier" do
      Asset.should_receive(:find_all_by_identifier).with('Test').and_return([mock_asset])
      request
    end

    it "should return an assets index presenter" do
      Asset.stub(:find_all_by_identifier).and_return([mock_asset])
      Presenter::AssetPresenter::Index.should_receive(:new).and_return('presenter')
      request.should eq('presenter')
    end

    it "should pass a search parameter and assets to the presenter" do
      Asset.stub(:find_all_by_identifier).and_return([mock_asset])
      Presenter::AssetPresenter::Index.should_receive(:new).with([mock_asset],"identifier matches 'Test'")
      request
    end

  end

  context "update" do

    let(:request) { AssetsController.new(params).put }

    context "without parameters" do

      let(:params)  { {} }

      it "should require an array of assets" do
        expect { request }.to raise_error(Controller::ParameterError,'No assets selected to complete')
      end
    end

    context "with parameters" do
      let(:params)  { {:complete=>{1=>1,2=>1,3=>1}} }
      let(:time) { DateTime.parse('01-02-2012 13:15') }
      let(:mock_asset) {
        double('asset',identifier:'fake',asset_type:double('asset_type',name:'type'))
      }

      it "should pass the assets and the current time to the asset completer" do
        DateTime.stub(:now).and_return { time }

        Asset.should_receive(:find).with(1,2,3).and_return([mock_asset])
        Asset::Completer.should_receive(:create!).with(
          assets: [mock_asset],
          time: time
        )
        request
      end
      it "should return an asset index presenter containing completed assets" do
        Asset.should_receive(:find).with(1,2,3).and_return([mock_asset])
        Asset::Completer.stub(:create!)
        Presenter::AssetPresenter::Index.should_receive(:new).with([mock_asset],'were updated').and_return('Pres')
        request.should eq('Pres')
      end
    end
  end

  context "show" do
    it "should raise an exception" do
      expect { AssetsController.new({}).get}.to raise_error(Controller::NotImplimented)
    end
  end

  context "create" do
    it "should raise an exception" do
      expect { AssetsController.new({}).post}.to raise_error(Controller::NotImplimented)
    end
  end



end
