class ChangeQcFlowColumnWorkflowsToNotNull < ActiveRecord::Migration
  def change
    change_column_null :workflows, :qc_flow, false
  end
end
