require './app/controllers/controller'
require './app/models/workflow'
require './app/presenters/workflow/show'

class WorkflowsController < Controller

  required_parameters_for :create, [:name], 'You must specify a name.'
  validate_parameters_for :create, :check_name,   'The name of the new workflow must be unique.'

  required_parameters_for :show,   [:workflow_id], 'You must specify a workflow.'

  required_parameters_for :update, [:name], 'You must specify a name.'
  required_parameters_for :update, [:workflow_id], 'You must specify a workflow.'

  def create
    Workflow::Creator.create!(
      :name        => params[:name],
      :has_comment => params[:hasComment] || false,
      :reportable  => params[:reportable] || false
    )
  end

  def show
    Presenter::WorkflowPresenter::Show.new(workflow)
  end

  def update
    Workflow::Updater.create!(
      :workflow    => workflow,
      :name        => params[:name],
      :has_comment => params[:hasComment] || false,
      :reportable  => params[:reportable] || false
    )
  end

  private

  def check_name
    ! Workflow.where(name:params[:name]).exists?
  end

  def workflow
    Workflow.find_by_id(params[:workflow_id])||user_error("There is no workflow with the id #{params[:workflow_id]}.")
  end

end
