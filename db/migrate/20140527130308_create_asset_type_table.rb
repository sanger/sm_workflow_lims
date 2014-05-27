class CreateAssetTypeTable < ActiveRecord::Migration
  def change
    create_table(:asset_types) do |t|
      # id
      t.string :name, :null => false
      t.string :identifier_type, :null => false
      t.timestamps
    end
  end
end
