class AddInitialStateToWorkflows < ActiveRecord::Migration
  def change
    add_reference :workflows, :initial_state
    add_foreign_key :workflows, :states, column: :initial_state_id
  end
end