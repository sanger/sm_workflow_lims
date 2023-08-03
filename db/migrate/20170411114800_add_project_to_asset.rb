class AddProjectToAsset < ActiveRecord::Migration[4.2]
  def change
    add_column :assets, :project, :string
  end
end
