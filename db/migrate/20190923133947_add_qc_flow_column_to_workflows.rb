class AddQcFlowColumnToWorkflows < ActiveRecord::Migration
  def change
    add_column :workflows, :qc_flow, :boolean
  end
end
