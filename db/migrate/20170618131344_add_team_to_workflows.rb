class AddTeamToWorkflows < ActiveRecord::Migration
  def change
    add_reference :workflows, :team
    add_index :workflows, :team_id
  end
end
