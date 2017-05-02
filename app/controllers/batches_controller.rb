class BatchesController < ApplicationController

# Validate everything/most part on model level?

  before_action :valid_date_provided, only: [:update, :create]
  before_action :batch_id_present?, only: [:show, :update, :delete]
  before_action :workflow_id_present?, only: [:create, :update]
  before_action :study_present?, only: [:create]
  before_action :asset_type_id_present?, only: [:create]
  before_action :assets_provided, only: [:create]

  # required_parameters_for :create, [:workflow_id], 'You must specify a workflow.'
  # required_parameters_for :create, [:asset_type_id], 'You must specify an asset type.'
  # required_parameters_for :create, [:study], 'You must specify a study.'

  # validate_parameters_for :create, :assets_provided, 'You must register at least one asset.'
  # validate_parameters_for :create, :valid_date_provided, 'Dates must be in the format DD/MM/YYYY and cannot be in the future.'

  # required_parameters_for :update, [:workflow_id], 'You must specify a workflow.'
  # required_parameters_for :update, [:batch_id], 'You must specify a batch.'
  # validate_parameters_for :update, :valid_date_provided, 'Dates must be in the format DD/MM/YYYY and cannot be in the future.'

  # required_parameters_for :remove, [:batch_id], 'You must specify a batch.'

  # required_parameters_for :show, [:batch_id], 'You must specify a batch.'

  def new
    @presenter = Presenter::BatchPresenter::New.new
  end

  def show
    @presenter = Presenter::BatchPresenter::Show.new(batch)
  end

  def update
    updated_batch = Batch::Updater.create!(
      batch: batch,
      study: params[:study],
      project: params[:project],
      workflow: workflow,
      cost_code: cost_code,
      pipeline_destination: pipeline_destination,
      begun_at: @date,
      comment: params[:comment]
      )
    @presenter = Presenter::BatchPresenter::Show.new(updated_batch)
    flash[:notice] = "The batch was updated."
    redirect_to("/batches/#{params[:batch_id]}")
  end

  def destroy
    batch.destroy!
    flash[:notice] = "The batch was deleted."
    redirect_to("/batches/new")
  end

  def create
    updated_batch = Batch::Creator.create!(
      study: params[:study],
      project: params[:project],
      workflow: workflow,
      pipeline_destination: pipeline_destination,
      begun_at: @date,
      cost_code: cost_code,
      asset_type: asset_type,
      assets: params[:assets].values,
      comment: params[:comment]
    )
    @presenter = Presenter::BatchPresenter::Show.new(updated_batch)
    flash[:notice] = "The batch was created."
    redirect_to("/batches/#{@presenter.id}")
  end

  private

  def batch_id_present?
    unless params[:batch_id].present?
      flash[:error] = 'You must specify a batch.'
    end
  end

  def workflow_id_present?
    unless params[:workflow_id].present?
      flash[:error] = 'You must specify a workflow.'
    end
  end

  def study_present?
    unless params[:study].present?
      flash[:error] = 'You must specify a study.'
    end
  end

  def asset_type_id_present?
    unless params[:asset_type_id].present?
      flash[:error] = 'You must specify an asset type.'
    end
  end

  #remove 'user_error' thing. Validate everything on model level?

  def workflow
    Workflow.find_by_id(params[:workflow_id])||user_error("There is no workflow with the id #{params[:workflow_id]}.")
  end

  def pipeline_destination
    return nil if params[:pipeline_destination_id].blank?
    PipelineDestination.find_by_id(params[:pipeline_destination_id])||user_error("There is no pipeline destination with the id #{params[:pipeline_destination_id]}.")
  end

  def cost_code
    return CostCode.find_or_create_by(:name => params[:cost_code]).tap{|c| c.save || user_error(CostCode.validationErrorMsg(:name)) } if params[:cost_code].present?
    nil
  end

  def asset_type
    AssetType.find_by_id(params[:asset_type_id])||user_error("There is no asset type with the id #{params[:asset_type_id]}.")
  end

  def batch
    Batch.find_by_id(params[:batch_id])||user_error("There is no batch with the id #{params[:batch_id]}.")
  end

  def assets_provided
    params[:assets] && params[:assets].keys.size > 0
  end

  def valid_date_provided
    @date = nil
    return true if params[:begun_at].blank?
    begin
      @date = DateTime.strptime(params[:begun_at],'%d/%m/%Y') + 12.hours
      @date < DateTime.now
    rescue ArgumentError
      flash[:error] = 'Dates must be in the format DD/MM/YYYY and cannot be in the future.'
      false
    end
  end

end