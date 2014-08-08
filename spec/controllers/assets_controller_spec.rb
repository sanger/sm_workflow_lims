require 'spec_helper'
require './app/controllers/assets_controller'

describe AssetsController do

  let(:mock_asset) {
    double('asset',identifier:'fake',asset_type:double('asset_type',name:'type'))
  }
  let(:searchless) { double('scope').tap {|s| s.should_receive(:with_identifier).with(nil).and_return([mock_asset]) }}

  context "index" do

    let(:request) { AssetsController.new(params).get_index }
    let(:params)  { {} }

    it "should look up all in progress assets" do
      Asset.should_receive(:in_progress).and_return(searchless)
      request
    end

    it "should return an assets index presenter" do
      Asset.stub(:in_progress).and_return(searchless)
      Presenter::AssetPresenter::Index.should_receive(:new).and_return('presenter')
      request.should eq('presenter')
    end

    it "should pass a nil search parameter and assets to the presenter" do
      Asset.stub(:in_progress).and_return(searchless)
      Presenter::AssetPresenter::Index.should_receive(:new).with([mock_asset],nil,'in_progress')
      request
    end

  end

  context "index with parameters" do

    # We'll shift to the join

    let(:request) { AssetsController.new(params).get_index }
    let(:params)  { {identifier:'Test',state:'all'} }

    it "should look up all assets with an identifier" do
      Asset.should_receive(:with_identifier).with('Test').and_return([mock_asset])
      request
    end

    it "should return an assets index presenter" do
      Asset.stub(:with_identifier).and_return([mock_asset])
      Presenter::AssetPresenter::Index.should_receive(:new).and_return('presenter')
      request.should eq('presenter')
    end

    it "should pass a search parameter and assets to the presenter" do
      Asset.stub(:with_identifier).and_return([mock_asset])
      Presenter::AssetPresenter::Index.should_receive(:new).with([mock_asset],"identifier matches 'Test'",'all')
      request
    end

  end

  context "index with state" do

    # We'll shift to the join

    let(:request) { AssetsController.new(params).get_index }
    let(:params)  { {:state=>'report_required'} }

    it "should look up all in report_required assets" do
      Asset.should_receive(:in_state).with('report_required').and_return(searchless)
      request
    end

    it "should return an assets index presenter" do
      Asset.stub(:in_state).and_return(searchless)
      Presenter::AssetPresenter::Index.should_receive(:new).and_return('presenter')
      request.should eq('presenter')
    end

    it "should pass a nil search parameter and assets to the presenter" do
      Asset.stub(:in_state).and_return(searchless)
      Presenter::AssetPresenter::Index.should_receive(:new).with([mock_asset],nil,'report_required')
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

        Asset.should_receive(:find).with([1,2,3]).and_return([mock_asset])
        Asset::Completer.should_receive(:create!).with(
          assets: [mock_asset],
          time: time
        )
        request
      end
      it "should return an asset index presenter containing completed assets" do
        Asset.should_receive(:find).with([1,2,3]).and_return([mock_asset])
        Asset::Completer.stub(:create!)
        Presenter::AssetPresenter::Index.should_receive(:new).with([mock_asset],'were updated',nil).and_return('Pres')
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
