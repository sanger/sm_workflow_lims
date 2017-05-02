require './app/controllers/controller'

class PipelineDestinationsController < Controller

  required_parameters_for :create, [:name],       'You must provide a name for the new pipeline'
  validate_parameters_for :create, :check_name,   'The name of the new pipeline must be unique'

  def check_name
    ! PipelineDestination.where(name:params[:name]).exists?
  end

  def create
    PipelineDestination::Creator.create!(params[:name])
  end

end
