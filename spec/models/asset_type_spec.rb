require 'rails_helper'

describe AssetType do
  context 'with valid parameters' do
    let(:test_name) { 'test' }
    let(:test_identifier_type) { 'type' }
    let(:asset_type) { create :asset_type, name: test_name, identifier_type: test_identifier_type }
    let(:asset_type_with_asset) { create :asset_type_with_asset, asset_identifier: 'test' }

    it 'can be created' do
      expect(asset_type).to be_valid
      expect(asset_type).to have(0).errors_on(:name)
      expect(asset_type).to have(0).errors_on(:identifier_type)
      expect(asset_type.name).to eq(test_name)
      expect(asset_type.identifier_type).to eq(test_identifier_type)
      expect(asset_type.has_sample_count).to be(false)
      expect(asset_type.identifier_data_type).to eq('alphanumeric')
      expect(asset_type.labware_type).to eq('Plate')
    end

    it 'has many assets' do
      expect(asset_type_with_asset.assets.size).to eq(1)
      expect(asset_type_with_asset.assets.first.identifier).to eq('test')
    end
  end

  context 'with invalid parameters' do
    it 'requires a name and identifier_type' do
      invalid_asset_type = AssetType.new
      expect(invalid_asset_type).to have(1).errors_on(:name)
      expect(invalid_asset_type).to have(1).errors_on(:identifier_type)
      expect(invalid_asset_type).to have(1).errors_on(:labware_type)
      expect(invalid_asset_type).not_to be_valid
    end
  end
end
