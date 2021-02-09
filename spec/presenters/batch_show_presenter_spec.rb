require 'rails_helper'
require './app/presenters/batch/show'
require './spec/presenters/shared_presenter_behaviour'

describe Presenter::BatchPresenter::Show do
  context 'with a batch' do
    let(:presenter) { Presenter::BatchPresenter::Show.new(test_batch) }
    let(:test_batch) { double('batch', assets: [asset1, asset2]) }
    let(:comment) { double('comment', comment: 'A comment') }
    let(:asset2) do
      double('asset_2',
             identifier: 'asset_2',
             asset_type: mock_type,
             workflow: mock_workflow,
             study: 'study',
             comment: comment)
    end
    let(:asset1) do
      double('asset_1',
             identifier: 'asset_1',
             asset_type: mock_type,
             workflow: mock_workflow,
             study: 'study',
             comment: comment)
    end
    let(:mock_workflow) { double('mock_wf', name: 'Work', has_comment: true) }
    let(:mock_type) { double('mock_type', name: 'Type', identifier_type: 'id', variable_samples: true) }

    include_examples('shared presenter behaviour')

    it 'yields each asset in the batch in turn for each_asset' do
      expect(Presenter::AssetPresenter::Asset).to receive(:new).with(asset1).and_call_original
      expect(Presenter::AssetPresenter::Asset).to receive(:new).with(asset2).and_call_original

      expect do |b|
        presenter.each_asset(&b)
      end.to yield_successive_args(Presenter::AssetPresenter::Asset, Presenter::AssetPresenter::Asset)
    end

    it 'returns the study_name (of the first asset) for study' do
      expect(presenter.study).to eq('study')
    end

    it 'returns the workflow (of the first asset) for workflow' do
      expect(presenter.workflow).to eq(mock_workflow)
    end

    it 'returns the comment (of the first asset) for comment' do
      expect(presenter.comment).to eq('A comment')
    end
  end
end
