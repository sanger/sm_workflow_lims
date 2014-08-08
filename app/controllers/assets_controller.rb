require './app/controllers/controller'

class AssetsController < Controller

  validate_parameters_for :update, :assets_provided, 'No assets selected to complete'

  def update
    Asset::Completer.create!(assets:assets,time:DateTime.now)
    Presenter::AssetPresenter::Index.new(assets,'were updated',nil)
  end

  def index
    assets = Asset.in_state(state).with_identifier(params[:identifier])
    Presenter::AssetPresenter::Index.new(assets,search,state)
  end

  private

  def state
    params[:state]||'in_progress'
  end

  def search
    params[:identifier] && "identifier matches '#{params[:identifier]}'"
  end

  def assets_provided
    params[:complete].is_a?(Hash) && params[:complete].keys.count > 0
  end

  def assets
    @assets||=Asset.find(params[:complete].keys)
  end


end
