require 'spec_helper'
require './app/models/asset'

describe Asset do

  context "with valid parameters" do

    let(:asset_type) { AssetType.new(:identifier_type=>'example',:name=>'test') }
    let(:identifier) { 'name' }
    let(:batch) { Batch.new }
    let(:workflow) { Workflow.new }
    let(:comment) { Comment.new }

    it 'can be created' do
      asset = Asset.new(
        :identifier => identifier,
        :batch      => batch,
        :asset_type => asset_type,
        :workflow   => workflow,
        :comment    => comment
      )
      expect(asset).to have(0).errors_on(:identifier)
      expect(asset).to have(0).errors_on(:batch)
      expect(asset).to have(0).errors_on(:workflow)
      expect(asset).to have(0).errors_on(:comment)
      expect(asset).to have(0).errors_on(:asset_type)

      expect(asset).to have(0).errors_on(:begun_at)

      asset.valid?.should eq(true)

      asset.identifier.should eq(identifier)
      asset.batch.should eq(batch)
      asset.asset_type.should eq(asset_type)
      asset.workflow.should eq(workflow)

      asset.begun_at.should eq(asset.created_at)
    end

    it 'should delegate identifier_type to asset_type' do

      asset = Asset.new(
        :identifier=>identifier,
        :batch=>batch,
        :asset_type=>asset_type,
        :workflow=>workflow
      )
      asset.identifier_type.should eq('example')
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

    it 'requires an identifier, batch, asset type and workflow' do
      asset = Asset.new()
      expect(asset).to have(1).errors_on(:identifier)
      expect(asset).to have(1).errors_on(:batch)
      expect(asset).to have(1).errors_on(:asset_type)
      expect(asset).to have(1).errors_on(:workflow)
      asset.valid?.should eq(false)
    end

  end

  context 'scopes' do

    let(:reportable_workflow)    { Workflow.create!(name:'reportable',    reportable:true ) }
    let(:nonreportable_workflow) { Workflow.create!(name:'nonreportable', reportable:false) }

    let(:basics) { {identifier:'one',asset_type_id:1,batch_id:1,workflow_id:1} }
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

    it 'should scope all' do
      Asset.in_state('all').should eq(Asset.all)
    end

    it 'should scope report_required' do
      Asset.should_receive(:report_required).and_return('valid')
      Asset.in_state('report_required').should eq('valid')
    end

    it 'should scope in_progress' do
      Asset.should_receive(:in_progress).and_return('valid')
      Asset.in_state('in_progress').should eq('valid')
    end

    it 'should scope invalid_states' do
      Asset.should_receive(:none).and_return('nothing')
      Asset.in_state('invalid_state').should eq('nothing')
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

end
