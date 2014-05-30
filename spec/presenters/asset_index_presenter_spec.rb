require 'spec_helper'
require './app/presenters/asset/index'
require './spec/presenters/shared_presenter_behaviour'

describe Presenter::AssetPresenter::Index do

  shared_examples "standard behaviour" do

    include_examples("shared presenter behaviour")

    let(:mock_type) { double('mock_type',name:'Type',identifier_type:'id',variable_samples:true)}
    let(:mock_type2) { double('mock_type2',name:'Type2',identifier_type:'id',variable_samples:true)}
    let(:mock_workflow)  { double('mock_wf',  name:'Work',has_comment:true)}
    let(:asset1) { double('asset_1',identifier:'asset_1',asset_type:mock_type,workflow:mock_workflow,study:'study') }
    let(:asset2) { double('asset_2',identifier:'asset_2',asset_type:mock_type2,workflow:mock_workflow,study:'study') }

    let(:assets) { [asset1,asset2] }

    let(:presenter) { Presenter::AssetPresenter::Index.new(assets,search)}

    it "should return a count of assets for total" do
      presenter.total.should eq(2)
    end
    it "should yield each asset of type x in turn for each_asset(x)" do
      expect { |b| presenter.each_asset('Type',&b) }.to yield_with_args(Presenter::AssetPresenter::Asset)
      presenter.each_asset('Type') {|a| a.identifier.should eq('asset_1')}
    end

  end

  context "when returning search results" do

    include_examples "standard behaviour"

    let(:search) {"identifier matches 'Type'"}

    it "should yield the search parameters on search_parameters" do
      expect { |b| presenter.search_parameters(&b) }.to yield_with_args(search)
    end
    # Eg. presenter.search_parameters {|sp| puts sp }
    # -> identifier matches 'my plate'
    it "should return true for is_search?" do
      presenter.is_search?.should eq(true)
    end

  end

  context "when returning a complete index" do

    include_examples "standard behaviour"

    let(:search) {nil}

    it "should not yield on search_parameters" do
      expect { |b| presenter.search_parameters(&b) }.to yield_successive_args()
    end
    # Eg. presenter.search_parameters {|sp| puts "Never called" }
    it "should return false for is_search?" do
      presenter.is_search?.should eq(false)
    end

  end

end
