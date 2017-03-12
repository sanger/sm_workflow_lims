class AddMultiTeamToWorkflows < ActiveRecord::Migration
  def change
    add_column :workflows, :multi_team_quant_essential, :boolean, default: false, null: false
  end
end