require './app/controllers/controller'
require './app/presenters/batch/new'
require './app/presenters/batch/show'

class BatchesController < Controller
  required_parameters_for :create, [:workflow_id], 'You must specify a workflow.'
  required_parameters_for :create, [:asset_type_id], 'You must specify an asset type.'
  required_parameters_for :create, [:study], 'You must specify a study.'

  validate_parameters_for :create, :assets_provided, 'You must register at least one asset.'

  required_parameters_for :update, [:workflow_id], 'You must specify a workflow.'
  required_parameters_for :update, [:batch_id], 'You must specify a batch.'

  required_parameters_for :show, [:batch_id], 'You must specify a batch.'

  def new
    Presenter::BatchPresenter::New.new
  end

  def show
    Presenter::BatchPresenter::Show.new(batch)
  end

  def create
    batch = Batch::Creator.create!(
      study: params[:study],
      workflow: workflow,
      asset_type: asset_type,
      assets: params[:assets].values
    )
    Presenter::BatchPresenter::Show.new(batch)
  end

  private

  def workflow
    Workflow.find_by_id(params[:workflow_id])||user_error("There is no workflow with the id #{params[:batch_id]}.")
  end

  def asset_type
    AssetType.find_by_id(params[:asset_type_id])||user_error("There is no asset type with the id #{params[:batch_id]}.")
  end

  def batch
    Batch.find_by_id(params[:batch_id])||user_error("There is no batch with the id #{params[:batch_id]}.")
  end

  def assets_provided
    params[:assets] && params[:assets].keys.size > 0
  end


end
