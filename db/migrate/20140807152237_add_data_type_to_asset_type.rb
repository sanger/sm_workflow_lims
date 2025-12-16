class AddDataTypeToAssetType < ActiveRecord::Migration[4.2]
  def change
    add_column :asset_types, :identifier_data_type, :string, default: 'alphanumeric', null: false
  end
end
