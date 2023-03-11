require './app/presenters/batch/new'
require './app/presenters/batch/show'

class BatchesController < ApplicationController
  before_action :batch, only: %i[show update remove]

  def new
    @presenter = Presenter::BatchPresenter::New.new
  end

  def show
    @presenter = Presenter::BatchPresenter::Show.new(batch)
  end

  def update
    batch_updater = Batch::Updater.new(
      batch:,
      study: params[:study],
      project: params[:project],
      workflow:,
      cost_code:,
      pipeline_destination:,
      begun_at: params[:begun_at],
      comment: params[:comment]
    )
    if batch_updater.valid?
      batch = batch_updater.update!
      @presenter = Presenter::BatchPresenter::Show.new(batch)
      flash[:notice] = I18n.t('batches.success.updated')
      redirect_to("/batches/#{params[:id]}")
    else
      flash[:error] = batch_updater.errors.full_messages.join('; ')
      redirect_back(fallback_location: root_path)
    end
  end

  def destroy
    batch.destroy!
    flash[:notice] = I18n.t('batches.success.deleted')
    redirect_to('/batches/new')
  end

  def create
    batch_creator = Batch::Creator.new(
      study: params[:study],
      project: params[:project],
      workflow:,
      pipeline_destination:,
      begun_at: params[:begun_at],
      cost_code:,
      asset_type:,
      assets:,
      comment: params[:comment]
    )
    if batch_creator.valid?
      batch = batch_creator.create!
      @presenter = Presenter::BatchPresenter::Show.new(batch)
      flash[:notice] = I18n.t('batches.success.created')
      redirect_to("/batches/#{@presenter.id}")
    else
      flash[:error] = batch_creator.errors.full_messages.join('; ')
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def workflow
    Workflow.find_by(id: params[:workflow_id])
  end

  def pipeline_destination
    PipelineDestination.find_by(id: params[:pipeline_destination_id])
  end

  def cost_code
    CostCode.find_or_create_by(name: params[:cost_code])
  end

  def asset_type
    AssetType.find_by(id: params[:asset_type_id])
  end

  def batch
    if params[:id].present?
      @batch ||= Batch.find_by(id: params[:id])
    else
      flash[:error] = I18n.t('batches.errors.none_selected')
      redirect_back(fallback_location: root_path)
    end
  end

  def assets
    params[:assets].values if assets_provided
  end

  def assets_provided
    params[:assets] && params[:assets].keys.size > 0
  end
end
