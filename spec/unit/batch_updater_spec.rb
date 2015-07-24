require 'spec_helper'
require './app/models/batch'

describe Batch::Updater do

  # Batch::Updater.should_receive(:create!).with(
  #   batch:'bat',
  #   workflow:'wf',
  #   study: 'test',
  #   comment:'comment',
  #   begun_at:DateTime.parse('25-06-2015 00:00')
  # )

  let(:study) { 'example_study' }
  let(:time)  { DateTime.parse('25-06-2015 00:00') }

  let(:comment) { 'Example comment' }

  let(:mock_batch) {
    mb = double('mock_batch')
    mb.stub(:assets).and_return { asset_association }
    mb.stub(:comments).and_return { [old_comment] }
    mb
  }
  let(:mock_comment) { double('mock_comment') }
  let(:old_comment) { double('old_comment', comment:'defunct')}

  let(:asset1) { double('asset1',identifier:'a',sample_count:1) }
  let(:asset2) { double('asset2',identifier:'b',sample_count:5) }
  let(:asset_association) { double('asset_association') }

  context "With comments and date" do

    let(:workflow) {
      cw = double('mock_comment_workflow')
      cw.stub(:has_comment?) {true}
      cw
    }

    it "should update the workflow, study and comment on all assets" do

      Comment.should_receive(:create!).with(:comment=>comment).once.and_return(mock_comment)
      old_comment.should_receive(:destroy).and_return(true)

      asset_association.should_receive(:update_all).with(study:study,workflow_id:workflow,pipeline_destination_id:nil,cost_code_id:nil,comment_id:mock_comment,begun_at:time)

      Batch::Updater.create!(
        batch:mock_batch,
        study:study,
        workflow:workflow,
        pipeline_destination:nil,
        cost_code:nil,
        begun_at: time,
        comment:comment
      ).should eq(mock_batch)
    end
  end

  context "Without comments or time" do

    let(:workflow) {
      cw = double('mock_workflow')
      cw.stub(:has_comment?) {false}
      cw
    }

    it "should update the workflow and comment on all assets" do

      Comment.should_not_receive(:create!)
      old_comment.should_receive(:destroy).and_return(true)

      asset_association.should_receive(:update_all).with(study:study,workflow_id:workflow,pipeline_destination_id:nil,cost_code_id:nil,comment_id:nil)

      Batch::Updater.create!(
        batch:mock_batch,
        study:study,
        workflow:workflow,
        pipeline_destination:nil,
        cost_code:nil,
        comment:comment,
        begun_at: nil
      ).should eq(mock_batch)
    end
  end



end
