require 'spec_helper'
require './app/models/asset'
require './app/models/event'

describe Asset do

  context "with valid parameters" do

    let!(:asset_type) { AssetType.new(:identifier_type=>'example',:name=>'test') }
    let!(:identifier) { 'name' }
    let!(:study) { 'study_A'}
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
      expect(asset.completed?).to be_false
      asset.events << (create :event, asset: asset, state: completed)
      expect(asset.completed?).to be_true
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

  context 'scopes' do

    let!(:state) { create :state, name: 'in_progress' }
    let!(:reportable_workflow)    { Workflow.create!(name:'reportable',    reportable:true, initial_state_name: 'in_progress' ) }
    let!(:nonreportable_workflow) { Workflow.create!(name:'nonreportable', reportable:false, initial_state_name: 'in_progress' ) }
    let!(:in_progress) { create :state, name: 'in_progress' }

    let(:basics) { { identifier:'one', asset_type_id:1, batch_id:1, workflow_id: reportable_workflow.id } }
    let(:completed) { basics.merge(completed_at:Time.now) }
    let(:created_last) { basics.merge(begun_at:Time.at(1000)) }
    let(:created_first) { basics.merge(begun_at:Time.at(10)) }

    let(:incomplete_reportable)    { basics.merge(workflow_id:reportable_workflow.id) }
    let(:complete_reportable)      { completed.merge(workflow_id:reportable_workflow.id) }
    let(:complete_nonreportable)   { completed.merge(workflow_id:nonreportable_workflow.id) }
    let(:reported_reportable)      { completed.merge(workflow_id:reportable_workflow.id,reported_at:Time.now ) }

    it 'in_progress filters on completed_at' do
      incomplete = Asset.new(basics)
      complete = Asset.new(completed)

      incomplete.save!(validate: false)
      complete.save!(validate: false)

      Asset.in_progress.should include(incomplete)
      Asset.in_progress.should_not include(complete)
    end

    it 'should return all if scope nil' do
      expect(Asset.in_state(nil)).to eq(Asset.all)
    end

    it 'reporting_required lists appropriate assets' do

      #TODO: Should look into testing this without needing database writes

      asset_incomplete_reportable = Asset.new(incomplete_reportable)
      asset_complete_reportable = Asset.new(complete_reportable)
      asset_complete_nonreportable = Asset.new(complete_nonreportable)
      asset_reported_reportable = Asset.new(reported_reportable)

      asset_incomplete_reportable.save!(validate: false)
      asset_complete_reportable.save!(validate: false)
      asset_complete_nonreportable.save!(validate: false)
      asset_reported_reportable.save!(validate: false)

      Asset.reportable.should     include(asset_complete_reportable)
      Asset.reportable.should     include(asset_incomplete_reportable)
      Asset.reportable.should_not include(asset_complete_nonreportable)
      Asset.reportable.should     include(asset_reported_reportable)

      Asset.report_required.should     include(asset_complete_reportable)
      Asset.report_required.should_not include(asset_incomplete_reportable)
      Asset.report_required.should_not include(asset_complete_nonreportable)
      Asset.report_required.should_not include(asset_reported_reportable)
    end

    it 'latest_first orders by created_at' do
      earliest = Asset.new(created_first)
      latest   = Asset.new(created_last)

      earliest.save!(validate: false)
      latest.save!(validate: false)

      Asset.latest_first.first.should eq(latest)
    end

    after do
      Workflow.destroy_all
      Asset.destroy_all
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
    let!(:state1) { create :state, name: 'in_progress' }
    let!(:state2) { create :state, name: 'completed' }
    let!(:state3) { create :state, name: 'report_required' }
    let(:asset) { create :asset }
    let(:reportable_asset) { create :asset, workflow: (create :workflow_reportable) }

    it 'should know the current state' do
      expect(asset.in_progress?).to be_true
      expect(asset.reported?).to be_false
    end

    it 'should create the right events' do
      expect(asset.events.count).to eq 1
      asset.complete
      expect(asset.events.count).to eq 2
      expect(asset.completed?).to be_true

      expect(reportable_asset.events.count).to eq 1
      reportable_asset.complete
      expect(reportable_asset.events.count).to eq 3
      expect(reportable_asset.report_required?).to be_true
    end

    it 'should not perform actions that are not valid' do
      expect { asset.perform_action('complete') }.to_not raise_error
      expect { asset.perform_action('some_action') }.to raise_error(StateMachine::StateMachineError)
    end
  end

end
