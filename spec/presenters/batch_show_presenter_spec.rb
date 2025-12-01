require 'rails_helper'

describe 'BatchPresenter::Show' do
  context 'with a batch' do
    let(:presenter) { BatchPresenter::Show.new(test_batch) }
    let(:test_batch) { double('batch', assets: [asset_first, asset_second]) }
    let(:comment) { double('comment', comment: 'A comment') }
    let(:asset_second) do
      double('asset_second',
             identifier: 'asset_second',
             asset_type: mock_type,
             workflow: mock_workflow,
             study: 'study',
             comment:)
    end
    let(:asset_first) do
      double('asset_first',
             identifier: 'asset_first',
             asset_type: mock_type,
             workflow: mock_workflow,
             study: 'study',
             comment:)
    end
    let(:mock_workflow) { double('mock_wf', name: 'Work', has_comment: true) }
    let(:mock_type) { double('mock_type', name: 'Type', identifier_type: 'id', variable_samples: true) }

    it_behaves_like('shared presenter behaviour')

    it 'yields each asset in the batch in turn for each_asset' do
      expect(AssetPresenter::Asset).to receive(:new).with(asset_first).and_call_original
      expect(AssetPresenter::Asset).to receive(:new).with(asset_second).and_call_original

      expect do |b|
        presenter.each_asset(&b)
      end.to yield_successive_args(AssetPresenter::Asset, AssetPresenter::Asset)
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
