require 'rails_helper'

describe AssetType do

  context "with valid parameters" do
    let(:test_name) { 'test' }
    let(:test_identifier_type) { 'type' }

    it 'can be created' do
      asset_type = AssetType.new(:name=>test_name,:identifier_type=>test_identifier_type)
      asset_type.valid?.should eq(true)
      expect(asset_type).to have(0).errors_on(:name)
      expect(asset_type).to have(0).errors_on(:identifier_type)
      asset_type.name.should eq(test_name)
      asset_type.identifier_type.should eq(test_identifier_type)
    end

    it 'has many assets' do
      asset_type = AssetType.new(:name=>test_name,:identifier_type=>test_identifier_type)
      asset_type.assets.new(:identifier=>'test')
      asset_type.assets.size.should eq(1)
      asset_type.assets.first.identifier.should eq('test')
    end

  end

  context "with invalid parameters" do

    it 'requires a name and identifier_type' do
      asset_type = AssetType.new()
      expect(asset_type).to have(1).errors_on(:name)
      expect(asset_type).to have(1).errors_on(:identifier_type)
      asset_type.valid?.should eq(false)
    end

  end

end
