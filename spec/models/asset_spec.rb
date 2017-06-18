require 'rails_helper'

describe Asset do

  context "with valid parameters" do

    let!(:asset_type) { AssetType.new(:identifier_type=>'example',:name=>'test') }
    let!(:identifier) { 'name' }
    let!(:study) { 'study_A'}
    let!(:project) { 'project'}
    let!(:batch) { Batch.new }
    let!(:workflow) { create :workflow }
    let!(:comment) { Comment.new }
    let!(:state) { create :state, name: 'in_progress'}
    let!(:completed) { create :state, name: 'completed'}
    let!(:asset) { Asset.new(
        identifier: identifier,
        batch:      batch,
        study:      study,
        asset_type: asset_type,
        workflow:   workflow,
        comment:    comment) }

    it 'can be created' do

      expect(asset).to have(0).errors_on(:identifier)
      expect(asset).to have(0).errors_on(:batch)
      expect(asset).to have(0).errors_on(:study)
      expect(asset).to have(0).errors_on(:project)
      expect(asset).to have(0).errors_on(:workflow)
      expect(asset).to have(0).errors_on(:comment)
      expect(asset).to have(0).errors_on(:asset_type)

      expect(asset).to have(0).errors_on(:begun_at)

      expect(asset.valid?).to eq(true)
      expect(asset.save).to eq(true)

      expect(asset.identifier).to eq(identifier)
      expect(asset.batch).to eq(batch)
      expect(asset.asset_type).to eq(asset_type)
      expect(asset.workflow).to eq(workflow)
      expect(asset.current_state).to eq 'in_progress'

      asset.begun_at.should eq(asset.created_at)
    end

    it 'should delegate identifier_type to asset_type' do
      asset.identifier_type.should eq('example')
    end

    it 'can have events' do
      expect(asset.events.count).to eq 0
      asset.save
      expect(asset.events.count).to eq 1
      create_list(:event, 3, asset: asset)
      expect(asset.events.count).to eq 4
    end

    it 'should know if it is completed' do
      asset.save
      expect(asset.completed?).to be_falsey
      asset.events << (create :event, asset: asset, state: completed)
      expect(asset.completed?).to be_truthy
    end


    context "with a defined begun time" do

      let(:begun_at) { DateTime.parse('01-02-2012 13:15').to_time }

      it 'requires an identifier, batch, asset type and workflow' do
        asset = Asset.new(
          :identifier => identifier,
          :batch      => batch,
          :asset_type => asset_type,
          :workflow   => workflow,
          :comment    => comment,
          :begun_at   => begun_at
        )

        asset.begun_at.should eq(begun_at)

        Timecop.freeze(begun_at+2.day) do
          asset.age.should == 2
        end

      end

    end

  end

  context "with invalid parameters" do
    let(:asset_type) { AssetType.new(:identifier_type=>'example',:name=>'test') }
    let(:identifier) { 'name' }
    let(:study) { 'study_A'}
    let(:batch) { Batch.new }
    let(:workflow) { Workflow.new }
    let(:comment) { Comment.new }

    it 'requires an identifier, batch, study, asset type and workflow' do
      asset = Asset.new()
      expect(asset).to have(1).errors_on(:identifier)
      expect(asset).to have(1).errors_on(:batch)
      expect(asset).to have(1).errors_on(:study)
      expect(asset).to have(1).errors_on(:asset_type)
      expect(asset).to have(1).errors_on(:workflow)
      asset.valid?.should eq(false)
    end

    it 'requires study to follow convention format (no spaces)' do
      asset = Asset.new(
        :identifier => identifier,
        :batch      => batch,
        :study      => 'Not valid because it has spaces',
        :asset_type => asset_type,
        :workflow   => workflow,
        :comment    => comment
      )
      expect(asset).to have(1).errors_on(:study)
    end

    it 'requires cost code to follow convention format (1 letter + digits)' do
      cost_code = CostCode.new(:name => 'NOT VALID')
      expect(cost_code).to have(1).errors_on(:name)
      cost_code = CostCode.new(:name => 'S1')
      expect(cost_code).to have(0).errors_on(:name)
    end
  end

  context 'in_state' do

    let!(:state) { create :state, name: 'in_progress' }
    let!(:reportable_workflow)    { create :workflow_reportable, name: 'reportable' }
    let!(:nonreportable_workflow) { create :workflow, name: 'nonreportable' }
    let!(:in_progress) { create :state, name: 'in_progress' }
    let!(:completed) { create :state, name: 'completed' }
    let!(:report_required) { create :state, name: 'report_required' }
    let!(:reported) { create :state, name: 'reported' }

    let(:basics) { { identifier:'one', asset_type_id: 1, batch_id: 1, workflow_id: reportable_workflow.id } }

    it 'in_progress filters on last event' do
      incompleted_asset = create :asset
      completed_asset = create :asset
      completed_asset.move_to(completed)

      Asset.in_state(in_progress).should include(incompleted_asset)
      Asset.in_state(in_progress).should_not include(completed_asset)
    end

    it 'should return all if scope nil' do
      expect(Asset.in_state(nil)).to eq(Asset.all)
    end

    it 'reporting_required lists appropriate assets' do
      asset_incomplete_reportable = create :asset, workflow: (create :workflow_reportable)

      asset_completed_reportable = create :asset, workflow: (create :workflow_reportable)
      asset_completed_reportable.move_to(completed)
      asset_completed_reportable.move_to(report_required)

      asset_completed_nonreportable = create :asset
      asset_completed_nonreportable.move_to(completed)

      asset_reported_reportable = create :asset, workflow: (create :workflow_reportable)
      asset_reported_reportable.move_to(completed)
      asset_completed_reportable.move_to(report_required)
      asset_reported_reportable.move_to(reported)

      Asset.in_state(report_required).should     include(asset_completed_reportable)
      Asset.in_state(report_required).should_not include(asset_incomplete_reportable)
      Asset.in_state(report_required).should_not include(asset_completed_nonreportable)
      Asset.in_state(report_required).should_not include(asset_reported_reportable)
    end

  end

  context 'removal of an asset' do
    let(:asset_type) { AssetType.new(:identifier_type=>'example',:name=>'test') }
    let(:identifier) { 'name' }
    let(:batch) { Batch.new }
    let(:workflow) { Workflow.new }

    it 'keeps comment if there are more assets using the same comment' do
      comment = Comment.new
      comment.assets.new(:identifier=>'test1')
      comment.assets.new(:identifier=>'test2')
      comment.assets.size.should eq(2)
      comment.assets.first.destroy!
      comment.destroyed?.should eq(false)
    end

    it 'destroys comment if there are no more assets using it' do
      comment = Comment.new
      comment.assets.new(:identifier=>'test1')
      comment.assets.new(:identifier=>'test2')
      comment.assets.size.should eq(2)
      comment.assets.each(&:destroy!)
      comment.destroyed?.should eq(true)
    end
  end

  context 'state machine' do
    let!(:in_progress) { create :state, name: 'in_progress' }
    let!(:completed) { create :state, name: 'completed' }
    let!(:report_required) { create :state, name: 'report_required' }
    let(:asset) { create :asset }
    let(:reportable_asset) { create :asset, workflow: (create :workflow_reportable) }

    it 'should know the current state' do
      expect(asset.in_progress?).to be_truthy
      expect(asset.reported?).to be_falsey
    end

    it 'should create the right events' do
      expect(asset.events.count).to eq 1
      asset.move_to(completed)
      expect(asset.events.count).to eq 2
      expect(asset.completed?).to be_truthy

      expect(reportable_asset.events.count).to eq 1
      reportable_asset.move_to(completed)
      reportable_asset.move_to_next(report_required)
      expect(reportable_asset.events.count).to eq 3
      expect(reportable_asset.report_required?).to be_truthy
    end

  end

  context 'for report' do

    let!(:workflow1) { create(:workflow, name: 'Workflow1') }
    let!(:workflow2) { create(:workflow, name: 'Workflow2') }
    let!(:in_progress) { create :state, name: 'in_progress' }
    let!(:completed) { create :state, name: 'completed' }
    let!(:cost_code) { create :cost_code}
    let!(:asset1) { create :asset, workflow: workflow1, study: 'Study1', project: 'Project1' }
    let!(:asset2) { create :asset, workflow: workflow1, study: 'Study1', project: 'Project2', cost_code: cost_code }
    let!(:asset3) { create :asset, workflow: workflow2, study: 'Study1', project: 'Project2' }
    let!(:asset4) { create :asset, workflow: workflow2, study: 'Study1', project: 'Project2' }
    let!(:asset5) { create :asset, workflow: workflow1}

    it 'should generate the right data for reports' do
      Timecop.freeze(Time.local(2017, 3, 7))
      asset1.move_to(completed)
      asset2.move_to(completed)
      asset3.move_to(completed)
      asset4.move_to(completed)
      start_date = Date.today - 1
      end_date = Date.today + 1
      expect(Asset.generate_report_data(start_date, end_date, workflow1)).to eq([{"study"=>"Study1", "project"=>"Project1", "cost_code_name"=>nil, "assets_count"=>1},
                                                                                  {"study"=>"Study1", "project"=>"Project2", "cost_code_name"=>cost_code.name, "assets_count"=>1}])
      expect(Asset.generate_report_data(start_date, end_date, workflow2)).to eq([{"study"=>"Study1", "project"=>"Project2", "cost_code_name"=>nil, "assets_count"=>2}])
    end

    after do
      Timecop.return
    end

  end

end
