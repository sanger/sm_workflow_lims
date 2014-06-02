require './app/controllers/controller'

class AssetsController < Controller

  validate_parameters_for :update, :assets_provided, 'No assets selected to complete'

  def update
    Asset::Completer.create!(assets:assets,time:DateTime.now)
    Presenter::AssetPresenter::Index.new(assets,'were updated')
  end

  def index
    if params[:identifier].present?
      assets = Asset.find_all_by_identifier(params[:identifier])
      search = "identifier matches '#{params[:identifier]}'"
    else
      assets = Asset.in_progress
      search = nil
    end
    Presenter::AssetPresenter::Index.new(assets,search)
  end

  private

  def assets_provided
    params[:complete].is_a?(Hash) && params[:complete].keys.count > 0
  end

  def assets
    @assets||=Asset.find(*params[:complete].keys)
  end


end
