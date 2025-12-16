class CreateAssetTable < ActiveRecord::Migration[4.2]
  def change
    create_table(:assets) do |t|
      # id
      t.string      :identifier,   null: false
      t.references  :asset_type,   null: false
      t.references  :workflow,     null: false
      t.references  :comment,      null: true
      t.references  :batch,        null: false
      t.string      :study
      t.integer     :sample_count, null: false, default: 1
      t.timestamps
      t.datetime :completed_at
    end
  end
end
