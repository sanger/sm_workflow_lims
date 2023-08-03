class UpdateStatesAndWorkflows < ActiveRecord::Migration[4.2]
  def change
    ActiveRecord::Base.transaction do
      Workflow.where(initial_state: nil).each do |workflow|
        workflow.update_attributes!(initial_state_name: 'in_progress')
      end
    end
  end
end
