require './app/controllers/controller'
require './app/models/workflow'
require './app/presenters/workflow/show'

class WorkflowsController < Controller

  required_parameters_for :create, [:name], 'You must specify a name.'
  validate_parameters_for :create, :check_name,   'The name of the new workflow must be unique.'
  validate_parameters_for :create, :check_turn_around, 'Turn around time must be an integer of zero or higher.'

  required_parameters_for :show,   [:workflow_id], 'You must specify a workflow.'

  required_parameters_for :update, [:name], 'You must specify a name.'
  required_parameters_for :update, [:workflow_id], 'You must specify a workflow.'
  validate_parameters_for :update, :check_turn_around, 'Turn around time must be an integer of zero or higher.'

  def create
    Workflow::Creator.create!(
      name:             params[:name],
      has_comment:      params[:hasComment] || false,
      reportable:       params[:reportable] || false,
      multi_team_quant_essential: params[:multi_team_quant_essential] || false,
      turn_around_days: params[:turn_around_days]
    )
  end

  def show
    Presenter::WorkflowPresenter::Show.new(workflow)
  end

  def update
    Workflow::Updater.create!(
      :workflow         => workflow,
      :name             => params[:name],
      :has_comment      => params[:hasComment] || false,
      :reportable       => params[:reportable] || false,
      :turn_around_days => turn_around_days
    )
  end

  private

  def check_name
    ! Workflow.where(name:params[:name]).exists?
  end

  def workflow
    Workflow.find_by_id(params[:workflow_id])||user_error("There is no workflow with the id #{params[:workflow_id]}.")
  end

  def check_turn_around
    /\A[0-9]*\Z/ === params[:turn_around_days]
  end

  def turn_around_days
    return nil if params[:turn_around_days].blank?
    params[:turn_around_days].to_i
  end

end
