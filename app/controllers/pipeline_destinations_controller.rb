class PipelineDestinationsController < ApplicationController
  def create
    @pipeline_destination = PipelineDestination.new(name: params[:name])
    if @pipeline_destination.valid?
      @pipeline_destination.save
      flash[:notice] = I18n.t('pipeline_destinations.success.created')
      redirect_to('/admin')
    else
      flash[:error] = @pipeline_destination.errors.full_messages.join('; ')
      redirect_back(fallback_location: root_path)
    end
  end
end
