class AddQcFlowColumnToWorkflows < ActiveRecord::Migration[4.2]
  def change
    add_column :workflows, :qc_flow, :boolean
  end
end
