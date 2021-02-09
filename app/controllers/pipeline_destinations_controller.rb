class PipelineDestinationsController < ApplicationController
  def create
    @pipeline_destination = PipelineDestination.new(name: params[:name])
    if @pipeline_destination.valid?
      @pipeline_destination.save
      flash[:notice] = 'The pipeline destination was created.'
      redirect_to('/admin')
    else
      flash[:error] = @pipeline_destination.errors.full_messages.join('; ')
      redirect_to :back
    end
  end
end
