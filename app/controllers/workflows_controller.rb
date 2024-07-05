require './app/presenters/workflow_presenter/show'

class WorkflowsController < ApplicationController
  include InitialState

  def show
    @presenter = Presenter::WorkflowPresenter::Show.new(workflow)
  end

  def create
    @workflow = Workflow.new(workflow_params)
    if @workflow.save
      flash[:notice] = I18n.t('workflows.success.created')
      redirect_to('/admin')
    else
      flash[:error] = @workflow.errors.full_messages.join('; ')
      redirect_back(fallback_location: root_path)
    end
  end

  def update
    workflow.assign_attributes(workflow_params)
    if workflow.save
      flash[:notice] = I18n.t('workflows.success.updated')
      redirect_to('/admin')
    else
      flash[:error] = workflow.errors.full_messages.join('; ')
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def workflow_params
    {
      name: params[:name],
      has_comment: params[:hasComment] || false,
      reportable: params[:reportable] || false,
      qc_flow: params[:qcFlow] || false,
      cherrypick_flow: params[:cherrypickFlow] || false,
      active: params[:active] || false,
      initial_state_name:,
      turn_around_days:
    }
  end

  def workflow
    @workflow ||= Workflow.find_by(id: params[:id])
  end

  def turn_around_days
    params[:turnAroundDays].to_i if params[:turnAroundDays].present?
  end

  def initial_state_name
    params[:initialStateName] || initial_state(params[:qcFlow], params[:cherrypickFlow])
  end
end
