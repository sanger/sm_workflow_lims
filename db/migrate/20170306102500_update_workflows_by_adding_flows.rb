class UpdateWorkflowsByAddingFlows < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      require './config/steps'
      require './config/flows'
      require './config/workflows'
      StepFactory.update
      FlowFactory.update
      WorkflowFactory.update
    end
  end
end