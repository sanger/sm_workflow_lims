class AddInitialStateToWorkflows < ActiveRecord::Migration
  def change
    add_reference :workflows, :initial_state
    add_index :workflows, :initial_state_id
  end
end