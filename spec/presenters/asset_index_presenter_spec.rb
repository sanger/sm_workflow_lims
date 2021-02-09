require 'rails_helper'
require './app/presenters/asset/index'
require './spec/presenters/shared_presenter_behaviour'

describe Presenter::AssetPresenter::Index do
  shared_context 'shared mocks' do
    let(:mock_type) do
      double('mock_type',
             name: 'Type',
             identifier_type: 'id',
             variable_samples: true)
    end
    let(:mock_type2) do
      double('mock_type2',
             name: 'Type2',
             identifier_type: 'id',
             variable_samples: true)
    end
    let(:mock_workflow) { double('mock_wf', name: 'Work', has_comment: true) }
    let(:asset1) do
      double('asset_1',
             identifier: 'asset_1',
             asset_type: mock_type,
             workflow: mock_workflow,
             study: 'study')
    end
    let(:asset2) do
      double('asset_2',
             identifier: 'asset_2',
             asset_type: mock_type2,
             workflow: mock_workflow,
             study: 'study')
    end
    let(:assets) { [asset1, asset2] }
    let!(:state) { create :state, name: 'in_progress' }
    let(:presenter) { Presenter::AssetPresenter::Index.new(assets, search, state) }
  end

  shared_examples 'standard behaviour' do
    include_examples('shared presenter behaviour')
    include_examples('shared mocks')

    it 'returns a count of assets for total' do
      expect(presenter.total).to eq(2)
    end

    it 'yields each asset of type x in turn for each_asset(x)' do
      expect { |b| presenter.each_asset('Type', &b) }.to yield_with_args(Presenter::AssetPresenter::Asset)
      presenter.each_asset('Type') do |asset|
        expect(asset.identifier).to eq('asset_1')
      end
    end
  end

  context 'when returning search results' do
    let(:search) { "identifier matches 'Type'" }

    include_examples 'standard behaviour'

    it 'yields the search parameters on search_parameters' do
      expect { |b| presenter.search_parameters(&b) }.to yield_with_args(search)
    end
    # Eg. presenter.search_parameters {|sp| puts sp }
    # -> identifier matches 'my plate'

    it 'returns true for is_search?' do
      expect(presenter.is_search?).to be_truthy
    end
  end

  context 'when returning a complete index' do
    let(:search) { nil }

    include_examples 'standard behaviour'

    it 'does not yield on search_parameters' do
      expect { |b| presenter.search_parameters(&b) }.to yield_successive_args
    end
    # Eg. presenter.search_parameters {|sp| puts "Never called" }

    it 'returns false for is_search?' do
      expect(presenter.is_search?).to be_falsey
    end
  end

  context 'when state is' do
    let(:search) { nil }

    include_examples 'shared mocks'

    context 'all' do
      let(:state) { nil }

      it 'has no action button' do
        expect { |b| presenter.action_button(&b) }.not_to yield_control
      end
    end

    context 'in_progress' do
      let(:state) { create :state, name: 'in_progress' }

      it 'has complete actions' do
        expect { |b| presenter.action_button(&b) }.to yield_with_args('Completed selected')
        expect(presenter.action).to eq('complete')
      end
    end

    context 'volume_check' do
      let(:state) { create :state, name: 'volume_check' }

      it 'has volume_check actions' do
        expect { |b| presenter.action_button(&b) }.to yield_with_args('Volume checked selected')
        expect(presenter.action).to eq('check_volume')
      end
    end

    context 'quant' do
      let(:state) { create :state, name: 'quant' }

      it 'has quant actions' do
        expect { |b| presenter.action_button(&b) }.to yield_with_args('Completed selected')
        expect(presenter.action).to eq('complete')
      end
    end

    context 'report_required' do
      let(:state) { create :state, name: 'report_required' }

      it 'has reporting actions' do
        expect { |b| presenter.action_button(&b) }.to yield_with_args('Reported selected')
        expect(presenter.action).to eq('report')
      end
    end
  end
end
