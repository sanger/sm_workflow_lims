class RenameFinishingStateToFinalState < ActiveRecord::Migration
  def change
    rename_column :procedures, :finishing_state_id, :final_state_id
  end
end
