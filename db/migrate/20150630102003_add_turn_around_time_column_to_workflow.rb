class AddTurnAroundTimeColumnToWorkflow < ActiveRecord::Migration[4.2]
  def change
    add_column :workflows, :turn_around_days, :integer
  end
end
