require 'rails_helper'

describe AssetType do

  context "with valid parameters" do
    let(:test_name) { 'test' }
    let(:test_identifier_type) { 'type' }

    it 'can be created' do
      asset_type = AssetType.new(:name=>test_name,:identifier_type=>test_identifier_type)
      expect(asset_type).to be_valid
      expect(asset_type).to have(0).errors_on(:name)
      expect(asset_type).to have(0).errors_on(:identifier_type)
      expect(asset_type.name).to eq(test_name)
      expect(asset_type.identifier_type).to eq(test_identifier_type)
    end

    it 'has many assets' do
      asset_type = AssetType.new(:name=>test_name,:identifier_type=>test_identifier_type)
      asset_type.assets.new(:identifier=>'test')
      expect(asset_type.assets.size).to eq(1)
      expect(asset_type.assets.first.identifier).to eq('test')
    end

  end

  context "with invalid parameters" do

    it 'requires a name and identifier_type' do
      asset_type = AssetType.new()
      expect(asset_type).to have(1).errors_on(:name)
      expect(asset_type).to have(1).errors_on(:identifier_type)
      expect(asset_type.valid?).to be_falsey
    end

  end

end
