class AddTurnAroundTimeColumnToWorkflow < ActiveRecord::Migration
  def change
    add_column :workflows, :turn_around_days, :integer
  end
end
