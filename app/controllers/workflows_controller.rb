require './app/controllers/controller'

class WorkflowsController < Controller

  validate_parameters_for :create, :check_name,   'The name of a new workflow must be unique in the system'

  def check_name
    !Workflow.all.map(&:name).include?(params[:name])
  end

  def create
    updated_batch = Workflow::Creator.create!(params[:name], params[:hasComment], params[:reportable])
    #Presenter::BatchPresenter::Show.new(updated_batch)
  end

end
