require './app/presenters/workflow/show'

class WorkflowsController < ApplicationController

  def create
    @workflow = Workflow.new(workflow_params)
    if @workflow.save
      flash[:notice] = "The workflow was created."
      redirect_to("/admin")
    else
      flash[:error] = @workflow.errors.full_messages.join('; ')
      redirect_to :back
    end
  end

  def show
    @presenter = Presenter::WorkflowPresenter::Show.new(workflow)
  end

  def update
    workflow.assign_attributes(workflow_params)
    if workflow.save
      flash[:notice] = "The workflow was updated."
      redirect_to("/admin")
    else
      flash[:error] = workflow.errors.full_messages.join('; ')
      redirect_to :back
    end
  end

  private

  def workflow_params
    { name:             params[:name],
    has_comment:      params[:hasComment] || false,
    reportable:       params[:reportable] || false,
    team: team,
    turn_around_days: turn_around_days }
  end

  def workflow
    @workflow ||= Workflow.find_by(id: params[:id])
  end

  def team
    @team ||= Team.find_by(id: params[:team])
  end

  def turn_around_days
    params[:turn_around_days].to_i if params[:turn_around_days].present?
  end

end