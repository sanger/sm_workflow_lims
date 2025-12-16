class ChangeQcFlowColumnWorkflowsToNotNull < ActiveRecord::Migration[4.2]
  def change
    change_column_null :workflows, :qc_flow, false
  end
end
