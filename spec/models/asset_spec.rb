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

      asset.valid?.should eq(true)

      asset.identifier.should eq(identifier)
      asset.batch.should eq(batch)
      asset.asset_type.should eq(asset_type)
      asset.workflow.should eq(workflow)
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

    let(:basics) { {identifier:'one',asset_type_id:1,batch_id:1,workflow_id:1} }
    let(:completed) { basics.merge(completed_at:Time.now) }
    let(:created_last) { basics.merge(created_at:Time.at(1000)) }
    let(:created_first) { basics.merge(created_at:Time.at(10)) }

    it 'in_progress filters on completed_at' do
      incomplete = Asset.new(basics)
      complete = Asset.new(completed)

      incomplete.save(validate: false)
      complete.save(validate: false)

      Asset.in_progress.should include(incomplete)
      Asset.in_progress.should_not include(complete)
    end

    it 'latest_first orders by created_at' do
      earliest = Asset.new(created_first)
      latest   = Asset.new(created_last)

      earliest.save(validate: false)
      latest.save(validate: false)

      Asset.latest_first.first.should eq(latest)
    end

    after do
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
