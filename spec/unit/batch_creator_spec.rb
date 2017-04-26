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
  let(:project) { 'example_project' }

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

  let!(:state) { create :state, name: 'in_progress' }

  context "With comments and date" do

    let(:workflow) {
      create :workflow_with_comment
    }

    let(:time)   { DateTime.parse('01-02-2003 00:00') }

    it "should create the batch, comment and assets" do
      Batch.should_receive(:new).once.and_return(mock_batch)
      Comment.should_receive(:create!).with(comment:comment).once.and_return(mock_comment)

      asset_association.should_receive(:build).with([
        {identifier:'a', sample_count: 1, asset_type: asset_type, comment: mock_comment, study: study, project: project, workflow: workflow, pipeline_destination: nil, cost_code: nil, begun_at: time},
        {identifier:'b', sample_count: 5, asset_type: asset_type, comment: mock_comment, study: study, project: project, workflow: workflow, pipeline_destination: nil, cost_code: nil, begun_at: time}
      ])

      mock_batch.should_receive(:save!).once
      Batch::Creator.create!(
        study:study,
        project: project,
        workflow:workflow,
        pipeline_destination:nil,
        cost_code:nil,
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
      create :workflow
    }

    it "should create the batch and assets" do
      Batch.should_receive(:new).once.and_return(mock_batch)

      asset_association.should_receive(:build).with([
        {identifier:'a',sample_count:1,asset_type:asset_type,study:study,project: project,workflow:workflow,pipeline_destination:nil,cost_code:nil,comment:nil,begun_at:nil},
        {identifier:'b',sample_count:5,asset_type:asset_type,study:study,project: project,workflow:workflow,pipeline_destination:nil,cost_code:nil,comment:nil,begun_at:nil}
      ])

      mock_batch.should_receive(:save!).once
      Batch::Creator.create!(
        study:study,
        project: project,
        workflow:workflow,
        pipeline_destination:nil,
        cost_code:nil,
        asset_type:asset_type,
        assets:[
          {identifier:'a',sample_count:1},
          {identifier:'b',sample_count:5}
        ],
        comment:comment
      )
    end

    it 'should create the right batch and the right assets' do
      assets = [{type: "Plate", identifier: "test", sample_count: "25"},
               {type: "Plate", identifier: "test2", sample_count: "10"},
               {type: "Plate", identifier: "test3", sample_count: "96"}]
      workflow = create :workflow

      batch_creator = Batch::Creator.new(
        study: 'study',
        project: 'project',
        assets: assets,
        asset_type: (create :asset_type_has_sample_count),
        workflow: workflow,
        pipeline_destination: (create :pipeline_destination),
        cost_code: (create :cost_code)
      )
      expect(Asset.count).to eq 0
      batch_creator.do!
      expect(Asset.count).to eq 3
      expect(Asset.last.current_state). to eq 'in_progress'
    end
  end

end
