class ChangeQcFlowColumnWorkflowsDefault < ActiveRecord::Migration
  def change
    change_column_default :workflows, :qc_flow, false
  end
end
