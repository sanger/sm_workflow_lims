class AssetsController < ApplicationController
  def index
    if params[:state].nil? && params[:identifier].nil?
      redirect_to('/assets?state=in_progress')
    else
      assets = Asset.in_state(state)
                    .with_identifier(params[:identifier])
      @presenter = AssetPresenter::Index.new(assets, search, state)
    end
  end

  # Assets updater creates new events for assets and moves assets to the next state
  def update
    if assets_provided
      updater = Asset::Updater.create!(assets: assets_to_be_updated, action: params[:asset_action])
      flash[updater.flash_status] = updater.message
      redirect_to("/assets?state=#{updater.redirect_state}")
    else
      flash[:error] = I18n.t('assets.errors.none_selected')
      redirect_back(fallback_location: root_path)
    end
  end

  private

  def state
    State.find_by(name: params[:state])
  end

  def search
    params[:identifier] && "batch id or asset identifier matches '#{params[:identifier]}'"
  end

  def assets_provided
    params[:assets].present?
  end

  def assets_to_be_updated
    @assets ||= Asset.find(params[:assets].keys)
  end
end
