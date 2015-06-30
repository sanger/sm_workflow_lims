require 'spec_helper'
require './app/models/batch'

describe Batch::Creator do

  # Batch::Creator.should_receive(:create!).
  # with(
  #   study:'test',
  #   workflow:'wf',
  #   asset_type:'at',
  #   begun_at: date,
  #   assets:[
  #     {identifier:'a',sample_count:1},
  #     {identifier:'b',sample_count:1}
  #   ],
  #   comment: 'comment'
  # )

  let(:study) { 'example_study' }

  let(:asset_type) { double('mock_asset_type',has_sample_count?:true) }

  let(:assets) {
    [
      {identifier:'a',sample_count:1},
      {identifier:'b',sample_count:5}
    ]
  }

  let(:comment) { 'Example comment' }

  let(:pipeline_destination) {
    {name:'Example Pipeline Destination'}
  }


  let(:mock_batch) {
    mb = double('mock_batch')
    mb.stub(:assets).and_return { asset_association }
    mb
  }
  let(:mock_comment) { double('mock_comment') }
  let(:asset_association) { double('asset_association')}

  context "With comments and date" do

    let(:workflow) {
      double('mock_workflow',has_comment?:true)
    }

    let(:time)   { DateTime.parse('01-02-2003 00:00') }

    it "should create the batch, comment and assets" do
      Batch.should_receive(:new).once.and_return(mock_batch)
      Comment.should_receive(:create!).with(comment:comment).once.and_return(mock_comment)

      asset_association.should_receive(:build).with([
        {identifier:'a',sample_count:1,asset_type:asset_type,comment:mock_comment,study:study,workflow:workflow,pipeline_destination:nil,begun_at:time},
        {identifier:'b',sample_count:5,asset_type:asset_type,comment:mock_comment,study:study,workflow:workflow,pipeline_destination:nil,begun_at:time}
      ])

      mock_batch.should_receive(:save!).once
      Batch::Creator.create!(
        study:study,
        workflow:workflow,
        pipeline_destination:nil,
        asset_type:asset_type,
        begun_at:time,
        assets:[
          {identifier:'a',sample_count:1},
          {identifier:'b',sample_count:5}
        ],
        comment:comment
      )
    end
  end

  context "Without comments or date" do

    let(:workflow) {
      wf = double('mock_workflow')
      wf.stub(:has_comment?) {false}
      wf
    }

    it "should create the batch and assets" do
      Batch.should_receive(:new).once.and_return(mock_batch)

      asset_association.should_receive(:build).with([
        {identifier:'a',sample_count:1,asset_type:asset_type,study:study,workflow:workflow,pipeline_destination:nil,comment:nil,begun_at:nil},
        {identifier:'b',sample_count:5,asset_type:asset_type,study:study,workflow:workflow,pipeline_destination:nil,comment:nil,begun_at:nil}
      ])

      mock_batch.should_receive(:save!).once
      Batch::Creator.create!(
        study:study,
        workflow:workflow,
        pipeline_destination:nil,
        asset_type:asset_type,
        assets:[
          {identifier:'a',sample_count:1},
          {identifier:'b',sample_count:5}
        ],
        comment:comment
      )
    end
  end

end
