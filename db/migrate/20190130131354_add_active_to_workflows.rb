class AddActiveToWorkflows < ActiveRecord::Migration
  def change
    add_column :workflows, :active, :boolean, default: true, null: false
  end
end
