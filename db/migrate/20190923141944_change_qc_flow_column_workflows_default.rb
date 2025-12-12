class ChangeQcFlowColumnWorkflowsDefault < ActiveRecord::Migration[4.2]
  def change
    change_column_default :workflows, :qc_flow, false
  end
end
