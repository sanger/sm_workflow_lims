class AddFlowToWorkflows < ActiveRecord::Migration
  def change
    add_reference :workflows, :flow
  end
end