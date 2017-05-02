require './app/controllers/controller'

class AssetsController < Controller

  validate_parameters_for :update, :assets_provided, 'No assets selected'

  def update
    Asset::Updater.create!(assets: assets_to_be_updated, action: params[:action])
  end

  def index
    assets = Asset.in_state(state)
                  .with_identifier(params[:identifier])
    Presenter::AssetPresenter::Index.new(assets, search, state)
  end

  private

  def state
    State.find_by(name: params[:state])
  end

  def search
    params[:identifier] && "identifier matches '#{params[:identifier]}'"
  end

  def assets_provided
    params[:assets].is_a?(Hash) && params[:assets].keys.present?
  end

  def assets_to_be_updated
    @assets||=Asset.find(params[:assets].keys)
  end

end
