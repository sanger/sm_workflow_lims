class AddForeignKeyConstraints < ActiveRecord::Migration[4.2]
  def change
    add_foreign_key :assets, :asset_types
    add_foreign_key :assets, :batches
    add_foreign_key :assets, :workflows
    add_foreign_key :assets, :comments
  end
end
