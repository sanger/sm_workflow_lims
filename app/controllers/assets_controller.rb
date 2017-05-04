require './app/presenters/asset/index'

class AssetsController < ApplicationController

  def update
    if assets_provided
      @presenter = Asset::Updater.create!(assets: assets_to_be_updated, action: params[:asset_action])
      flash[@presenter.flash_status] = @presenter.message
      redirect_to("/assets?state=#{@presenter.redirect_state}")
    else
      flash[:error] = 'No assets selected'
      redirect_to :back
    end
  end

  def index
    if params[:state].nil? && params[:identifier].nil?
      redirect_to("/assets?state=in_progress")
    else
      assets = Asset.in_state(state)
                    .with_identifier(params[:identifier])
      @presenter = Presenter::AssetPresenter::Index.new(assets, search, state)
    end
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