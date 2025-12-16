class AddActiveToWorkflows < ActiveRecord::Migration[4.2]
  def change
    add_column :workflows, :active, :boolean, default: true, null: false
  end
end
