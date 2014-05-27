class CreateAssetTable < ActiveRecord::Migration
  def change
    create_table(:assets) do |t|
      # id
      t.string      :identifier,   :null => false
      t.references  :asset_type,   :null => false
      t.references  :workflow,     :null => false
      t.references  :batch,        :null => false
      t.integer     :sample_count, :null=> false, :default => 1
      t.timestamps
      t.datetime    :completed_at

      t.index :batch_id
    end
  end
end
