require './app/controllers/controller'

class AssetsController < Controller

  validate_parameters_for :update, :assets_provided, 'No assets selected'
  # validate_parameters_for :update, :single_action,   'You cannot complete and report assets at the same time'

  def update

    Asset::Updater.create!(assets: assets_to_be_updated, time:DateTime.now) if update_assets?
    # (Asset::Completer.create!(assets:completed_assets,time:DateTime.now) if completed_assets?)||
    # (Asset::Reporter.create!( assets:reported_assets, time:DateTime.now) if reported_assets?)
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

  # def completed_assets?
  #   params[:complete].is_a?(Hash) && params[:complete].keys.present?
  # end

  # def reported_assets?
  #   params[:report].is_a?(Hash) && params[:report].keys.present?
  # end

  def assets_provided
    update_assets? || completed_assets? || reported_assets?
  end

  # def single_action
  #   completed_assets? ^ reported_assets?
  # end

  def assets_to_be_updated
    @assets||=Asset.find(params[:update].keys)
  end

  # def completed_assets
  #   @assets||=Asset.find(params[:complete].keys)
  # end

  # def reported_assets
  #   @assets||=Asset.find(params[:report].keys)
  # end

end
