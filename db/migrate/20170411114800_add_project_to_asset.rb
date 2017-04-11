class AddProjectToAsset < ActiveRecord::Migration
  def change
    add_column :assets, :project, :string
  end
end