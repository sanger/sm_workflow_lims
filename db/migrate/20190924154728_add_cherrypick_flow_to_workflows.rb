class AddCherrypickFlowToWorkflows < ActiveRecord::Migration[4.2]
  def change
    add_column :workflows, :cherrypick_flow, :boolean, default: false, null: false
  end
end
