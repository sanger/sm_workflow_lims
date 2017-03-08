require './app/controllers/controller'

class AssetsController < Controller

  validate_parameters_for :update, :assets_provided, 'No assets selected'

  def update
    Asset::Updater.create!(assets: assets_to_be_updated, time:DateTime.now) if update_assets?
  end

  def index
    assets = Asset.in_state(state).with_identifier(params[:identifier])
    Presenter::AssetPresenter::Index.new(assets,search,state)
  end

  private

  def state
    params[:state]
  end

  def search
    params[:identifier] && "identifier matches '#{params[:identifier]}'"
  end

  def update_assets?
    params[:update].is_a?(Hash) && params[:update].keys.present?
  end

  def assets_provided
    update_assets?
  end

  def assets_to_be_updated
    @assets||=Asset.find(params[:update].keys)
  end

end
