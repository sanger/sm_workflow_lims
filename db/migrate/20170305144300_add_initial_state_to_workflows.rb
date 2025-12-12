class AddInitialStateToWorkflows < ActiveRecord::Migration[4.2]
  def change
    add_reference :workflows, :initial_state
    add_index :workflows, :initial_state_id
  end
end
