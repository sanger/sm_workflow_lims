class AddCherrypickFlowToWorkflows < ActiveRecord::Migration
  def change
    add_column :workflows, :cherrypick_flow, :boolean, default: false, null: false
  end
end
