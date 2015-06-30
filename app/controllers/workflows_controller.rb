require './app/controllers/controller'

class WorkflowsController < Controller

  required_parameters_for :create, [:name], 'You must provide a name for the new workflow'
  validate_parameters_for :create, :check_name,   'The name of the new workflow must be unique'

  def check_name
    ! Workflow.where(name:params[:name]).exists?
  end

  def create
    Workflow::Creator.create!(
      :name        => params[:name],
      :has_comment => params[:hasComment] || false,
      :reportable  => params[:reportable] || false
    )
  end

end
