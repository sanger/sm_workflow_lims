class AddIndexesToTables < ActiveRecord::Migration[4.2]
  def change
    add_index :assets, :identifier
    add_index :assets, :asset_type_id
    add_index :assets, :batch_id
    add_index :assets, :workflow_id
    add_index :assets, :comment_id
  end
end
