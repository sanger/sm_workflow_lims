class AddLabwareTypeToAssetTypes < ActiveRecord::Migration[4.2]
  def change
    add_column :asset_types, :labware_type, :string
  end
end
