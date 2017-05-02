class AddIndexesToTables < ActiveRecord::Migration

  def change
    add_index :assets, :identifier
    add_index :assets, :completed_at
  end
end
