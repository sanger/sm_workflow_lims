require 'spec_helper'
require './app/presenters/batch/show'
require './spec/presenters/shared_presenter_behaviour'

describe Presenter::BatchPresenter::Show do

  context "with a batch" do

    include_examples("shared presenter behaviour")

    let(:mock_type) { double('mock_type',name:'Type',identifier_type:'id',variable_samples:true)}
    let(:mock_workflow)  { double('mock_wf',  name:'Work',has_comment:true)}
    let(:asset1) { double('asset_1',identifier:'asset_1',asset_type:mock_type,workflow:mock_workflow,study:'study',comment:comment) }
    let(:asset2) { double('asset_2',identifier:'asset_2',asset_type:mock_type,workflow:mock_workflow,study:'study',comment:comment) }
    let(:comment) { double('comment',:comment=>'A comment')}

    let(:test_batch) do
      double('batch',assets:[asset1,asset2])
    end

    let(:presenter) { Presenter::BatchPresenter::Show.new(test_batch) }

    it "should yield each asset in the batch in turn for each_asset" do

      Presenter::AssetPresenter::Asset.should_receive(:new).with(asset1).and_call_original
      Presenter::AssetPresenter::Asset.should_receive(:new).with(asset2).and_call_original

      expect { |b| presenter.each_asset(&b) }.to yield_successive_args(Presenter::AssetPresenter::Asset,Presenter::AssetPresenter::Asset)
    end

    it "should return the study_name (of the first asset) for study" do
      presenter.study.should eq('study')
    end

    it "should return the workflow (of the first asset) for workflow" do
      presenter.workflow.should eq('Work')
    end

    it "should return the comment (of the first asset) for comment" do
      presenter.comment.should eq('A comment')
    end
  end
end

