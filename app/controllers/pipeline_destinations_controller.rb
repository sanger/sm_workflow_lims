require './app/controllers/controller'

class PipelineDestinationsController < Controller

  validate_parameters_for :create, :check_name,   'The name of a new pipeline destination must be unique in the system'

  def check_name
    !PipelineDestination.all.map(&:name).include?(params[:name])
  end

  def create
    pipeline_dst = PipelineDestination::Creator.create!(params[:name])
    #Presenter::BatchPresenter::Show.new(updated_batch)
  end

end
