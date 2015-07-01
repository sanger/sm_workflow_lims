require './app/controllers/controller'
require './app/presenters/batch/new'
require './app/presenters/batch/show'


class BatchesController < Controller

  required_parameters_for :create, [:workflow_id], 'You must specify a workflow.'
  required_parameters_for :create, [:asset_type_id], 'You must specify an asset type.'
  required_parameters_for :create, [:study], 'You must specify a study.'

  validate_parameters_for :create, :assets_provided, 'You must register at least one asset.'
  validate_parameters_for :create, :valid_date_provided, 'Dates must be in the format DD/MM/YYYY and cannot be in the future.'

  required_parameters_for :update, [:workflow_id], 'You must specify a workflow.'
  required_parameters_for :update, [:batch_id], 'You must specify a batch.'
  validate_parameters_for :update, :valid_date_provided, 'Dates must be in the format DD/MM/YYYY and cannot be in the future.'

  required_parameters_for :remove, [:batch_id], 'You must specify a batch.'

  required_parameters_for :show, [:batch_id], 'You must specify a batch.'

  def new
    Presenter::BatchPresenter::New.new
  end

  def show
    Presenter::BatchPresenter::Show.new(batch)
  end

  def update
    updated_batch = Batch::Updater.create!(
      batch: batch,
      study: params[:study],
      workflow: workflow,
      pipeline_destination: pipeline_destination,
      begun_at: @date,
      comment: params[:comment]
      )
    Presenter::BatchPresenter::Show.new(updated_batch)
  end

  def remove
    batch.destroy!
  end

  def create
    updated_batch = Batch::Creator.create!(
      study: params[:study],
      workflow: workflow,
      pipeline_destination: pipeline_destination,
      begun_at: @date,
      asset_type: asset_type,
      assets: params[:assets].values,
      comment: params[:comment]
    )
    Presenter::BatchPresenter::Show.new(updated_batch)
  end

  private

  def workflow
    Workflow.find_by_id(params[:workflow_id])||user_error("There is no workflow with the id #{params[:workflow_id]}.")
  end

  def pipeline_destination
    return nil if params[:pipeline_destination_id].blank?
    PipelineDestination.find_by_id(params[:pipeline_destination_id])||user_error("There is no pipeline destination with the id #{params[:pipeline_destination_id]}.")
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
      false
    end
  end


end
