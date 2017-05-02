class QcWorkflowsAreReportable < ActiveRecord::Migration
  def change
    ActiveRecord::Base.transaction do
      require './config/workflows'
      WorkflowFactory.update
    end
  end
end
