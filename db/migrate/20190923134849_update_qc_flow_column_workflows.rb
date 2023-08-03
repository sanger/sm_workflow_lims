class UpdateQcFlowColumnWorkflows < ActiveRecord::Migration[4.2]
  def up
    Workflow.includes(:initial_state).each do |workflow|
      workflow.qc_flow = workflow.initial_state.name != 'in_progress'
      workflow.save
    end
  end

  def down
    Workflow.update_all(qc_flow: nil)
  end
end
