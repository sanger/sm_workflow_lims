# frozen_string_literal: true

module AssetTypeFactory
  def self.asset_types
    [
      {
        name: 'High Throughput',
        identifier_type: 'Name',
        has_sample_count: true,
        identifier_data_type: 'alphanumeric',
        labware_type: 'Plate'
      },
      {
        name: 'Sample Management',
        identifier_type: 'ID',
        has_sample_count: true,
        identifier_data_type: 'alphanumeric',
        labware_type: 'Plate'
      },
      {
        name: 'Tube',
        identifier_type: 'ID',
        has_sample_count: false,
        identifier_data_type: 'alphanumeric',
        labware_type: 'Tube'
      },
      {
        name: 'Extraction Sample Tube',
        identifier_type: 'Name',
        has_sample_count: false,
        identifier_data_type: 'alphanumeric',
        labware_type: 'Tube'
      }
    ]
  end

  def self.seed
    AssetType.create!(asset_types)
  end
end
