class WorkflowsController < ApplicationController

# Validate everything/most part on model level?
  before_action :check_name, only: [:create]
  before_action :name_present?, only: [:create, :update]
  before_action :workflow_id_present?, only: [:show, :update]
  before_action :check_turn_around, only: [:create, :update]

  # required_parameters_for :create, [:name], 'You must specify a name.'
  # validate_parameters_for :create, :check_name,   'The name of the new workflow must be unique.'
  validate_parameters_for :create, :check_turn_around, 'Turn around time must be an integer of zero or higher.'

  # required_parameters_for :show,   [:workflow_id], 'You must specify a workflow.'

  # required_parameters_for :update, [:name], 'You must specify a name.'
  # required_parameters_for :update, [:workflow_id], 'You must specify a workflow.'
  validate_parameters_for :update, :check_turn_around, 'Turn around time must be an integer of zero or higher.'

  def create
    @presenter = Workflow::Creator.create!(
      name:             params[:name],
      has_comment:      params[:hasComment] || false,
      reportable:       params[:reportable] || false,
      initial_state_name:    params[:initial_state_name],
      turn_around_days: params[:turn_around_days]
    )
    flash[:notice] = ['success',"The workflow was created."]
    redirect_to("/admin")
  end

  def show
    @presenter = Presenter::WorkflowPresenter::Show.new(workflow)
  end

  def update
    @presenter = Workflow::Updater.create!(
      workflow:         workflow,
      name:             params[:name],
      has_comment:      params[:hasComment] || false,
      reportable:       params[:reportable] || false,
      initial_state_name:    params[:initial_state_name],
      turn_around_days: turn_around_days
    )
    flash[:notice] = ["The workflow was updated."]
    redirect_to("/admin")
  end

  private

  def check_name
    unless Workflow.where(name:params[:name]).exists?
      flash[:error] = 'The name of the new workflow must be unique'
    end
  end

  def workflow
    Workflow.find_by_id(params[:workflow_id])||user_error("There is no workflow with the id #{params[:workflow_id]}.")
  end

  def check_turn_around
    unless /\A[0-9]*\Z/ === params[:turn_around_days]
      flash[:error] = 'Turn around time must be an integer of zero or higher.'
    end
  end

  def turn_around_days
    return nil if params[:turn_around_days].blank?
    params[:turn_around_days].to_i
  end

  def name_present?
    unless params[:name].present?
      flash[:error] = 'You must specify a name.'
    end
  end

  def workflow_id_present?
    unless params[:workflow_id].present?
      flash[:error] = 'You must specify a workflow.'
    end
  end

end