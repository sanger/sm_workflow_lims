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

end
