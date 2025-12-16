class CreateAssetTypeTable < ActiveRecord::Migration[4.2]
  def change
    create_table(:asset_types) do |t|
      # id
      t.string :name,                null: false
      t.string :identifier_type,     null: false
      t.boolean :has_sample_count,   null: false, default: false
      t.timestamps
    end
  end
end
