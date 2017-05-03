class PipelineDestinationsController < ApplicationController

  # before_action :check_name, only: [:create]
  # before_action :name_present?, only: [:create]

  # required_parameters_for :create, [:name],       'You must provide a name for the new pipeline'
  # validate_parameters_for :create, :check_name,   'The name of the new pipeline must be unique'

  def check_name
    unless PipelineDestination.where(name:params[:name]).exists?
      flash[:error] = 'The name of the new pipeline must be unique'
    end
  end

  def name_present?
    unless params[:name].present?
      flash[:error] = 'You must provide a name for the new pipeline'
    end
  end

  def create
    @presenter = PipelineDestination::Creator.create!(params[:name])
    flash[:notice] = "The pipeline destination was created."
    redirect_to("/admin")
  end

end