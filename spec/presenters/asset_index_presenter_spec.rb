require 'rails_helper'
require './app/presenters/asset/index'
require './spec/presenters/shared_presenter_behaviour'

describe Presenter::AssetPresenter::Index do

  shared_examples "shared mocks" do
    let(:mock_type) { double('mock_type',name:'Type',identifier_type:'id',variable_samples:true)}
    let(:mock_type2) { double('mock_type2',name:'Type2',identifier_type:'id',variable_samples:true)}
    let(:mock_workflow)  { double('mock_wf',  name:'Work',has_comment:true)}
    let(:asset1) { double('asset_1',identifier:'asset_1',asset_type:mock_type,workflow:mock_workflow,study:'study') }
    let(:asset2) { double('asset_2',identifier:'asset_2',asset_type:mock_type2,workflow:mock_workflow,study:'study') }
    let(:assets) { [asset1,asset2] }
    let!(:state) { create :state, name: 'in_progress'}
    let(:presenter) { Presenter::AssetPresenter::Index.new(assets,search,state)}
  end

  shared_examples "standard behaviour" do

    include_examples("shared presenter behaviour")
    include_examples("shared mocks")

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

  context "when state is" do

    include_examples "shared mocks"
    let(:search) {nil}

    context 'all' do
      let(:state)  { nil }

      it "should have no action button" do
        expect { |b| presenter.action_button(&b) }.not_to yield_control
      end
    end
    context 'in_progress' do
      let(:state) { create :state, name: 'in_progress'}

      it "should have complete actions" do
        expect { |b| presenter.action_button(&b) }.to yield_with_args('Completed selected')
        expect(presenter.action).to eq ('complete')
      end
    end
    context 'volume_check' do
      let(:state)  { create :state, name: 'volume_check'}

      it "should have volume_check actions" do
        expect { |b| presenter.action_button(&b) }.to yield_with_args('Volume checked selected')
        expect(presenter.action).to eq ('check_volume')
      end
    end
    context 'quant' do
      let(:state)  { create :state, name: 'quant'}

      it "should have quant actions" do
        expect { |b| presenter.action_button(&b) }.to yield_with_args('Completed selected')
        expect(presenter.action).to eq ('complete')
      end
    end
    context 'report_required' do
      let(:state)  { create :state, name: 'report_required'}

      it "should have reporting actions" do
        expect { |b| presenter.action_button(&b) }.to yield_with_args('Reported selected')
        expect(presenter.action).to eq ('report')
      end
    end
  end

end
