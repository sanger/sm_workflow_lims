class AddLabwareTypeToAssetTypes < ActiveRecord::Migration
  def change
    add_column :asset_types, :labware_type, :string
  end
end
