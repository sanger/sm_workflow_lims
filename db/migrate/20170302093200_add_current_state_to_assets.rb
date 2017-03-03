class AddCurrentStateToAssets < ActiveRecord::Migration
  def change
    add_column :assets, :current_state, :string
  end
end