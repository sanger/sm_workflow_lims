class UpdateWorkflowsAndStates < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      require './config/states'
      require './config/workflows'
      StateFactory.update
      WorkflowFactory.update
    end
  end
end