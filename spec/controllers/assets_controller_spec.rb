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
        expect { request }.to raise_error(Controller::ParameterError,'No assets selected')
      end
    end

    context "with complete" do
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
      it "should return a result object with accurate information" do
        Asset.should_receive(:find).with([1,2,3]).and_return([mock_asset])
        Asset::Completer.stub(:create!).and_return(double('mock_completer',state:'success',message:'Your stuff worked'))
        result = request
        result.state.should eq('success')
        result.message.should eq('Your stuff worked')
      end
    end

    context "with report" do
      let(:params)  { {:report=>{1=>1,2=>1,3=>1}} }
      let(:time) { DateTime.parse('01-02-2012 13:15') }
      let(:mock_asset) {
        double('asset',identifier:'fake',asset_type:double('asset_type',name:'type'))
      }

      it "should pass the assets and the current time to the asset reporter" do
        DateTime.stub(:now).and_return { time }

        Asset.should_receive(:find).with([1,2,3]).and_return([mock_asset])
        Asset::Reporter.should_receive(:create!).with(
          assets: [mock_asset],
          time: time
        )
        request
      end
      it "should return a result object with accurate information" do
        Asset.should_receive(:find).with([1,2,3]).and_return([mock_asset])
        Asset::Reporter.stub(:create!).and_return(double('mock_completer',state:'success',message:'Your stuff worked'))
        result = request
        result.state.should eq('success')
        result.message.should eq('Your stuff worked')
      end
    end

    context "with both" do
      let(:params)  { {:report=>{1=>1,2=>1},:complete=>{3=>1}} }
      let(:time) { DateTime.parse('01-02-2012 13:15') }
      let(:mock_asset) {
        double('asset',identifier:'fake',asset_type:double('asset_type',name:'type'))
      }

      it "should reject the request" do
        # We shouldn't actually have anyone trying to do this through the interface
        expect { request }.to raise_error(Controller::ParameterError,'You cannot complete and report assets at the same time')
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
