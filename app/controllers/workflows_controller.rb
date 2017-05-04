require './app/presenters/workflow/show'

class WorkflowsController < ApplicationController

  # before_action :workflow, only: [:show, :update]

  def create
    @workflow = Workflow.new(workflow_params)
    if @workflow.valid?
      @workflow.save
      #flash does not appear on page, feature test fails
      flash[:notice] = "The workflow was created."
      #if I add notice, flash still does not appear on page, but feature test passes
      redirect_to("/admin", notice: "The workflow was created.")
    else
      flash[:error] = @workflow.errors.full_messages
      redirect_to :back
    end
  end

  def show
    @presenter = Presenter::WorkflowPresenter::Show.new(workflow)
  end

  def update
    workflow.assign_attributes(workflow_params)
    if workflow.valid?
      workflow.save
      flash[:notice] = "The workflow was updated."
      redirect_to("/admin")
    else
      flash[:error] = workflow.errors.full_messages
      redirect_to :back
    end
  end

  private

  def workflow_params
    { name:             params[:name],
    has_comment:      params[:hasComment] || false,
    reportable:       params[:reportable] || false,
    initial_state_name:    params[:initial_state_name],
    turn_around_days: turn_around_days }
  end

  def workflow
    @workflow ||= Workflow.find_by_id(params[:id])
  end

  def turn_around_days
    params[:turn_around_days].to_i if params[:turn_around_days].present?
  end


end