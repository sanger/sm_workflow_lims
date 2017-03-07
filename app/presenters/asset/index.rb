require './app/presenters/presenter'
require './app/presenters/asset/asset'

module Presenter::AssetPresenter
  class Index < Presenter

    attr_reader :search, :assets, :total

    def initialize(found_assets,search=nil,state=nil)
      @total  = found_assets.count
      @assets = found_assets.group_by {|a| a.asset_type.name}.tap {|h| h.default = [] }
      @search = search
      @state  = state||'in_progress'
    end

    def asset_identifiers
      assets.values.flatten.map(&:identifier)
    end

    def has_assets?(type)
      return assets[type].length > 0
    end

    def num_assets(type)
      return assets[type].length
    end

    def assets_from_batch(type, batch_id)
      @assets[type].select{|a| a.batch.id==batch_id}
    end

    def each_asset(type)
      if assets[type].nil?
        return
      end
      assets[type].each do |asset|
        yield Presenter::AssetPresenter::Asset.new(asset)
      end
    end

    def search_parameters
      yield search if is_search?
    end

    def is_search?
      search.present?
    end

    def workflow
      'None'
    end

    def state
      @state.humanize
    end

    def action
      yield 'update'
      # {
      #   'in_progress' => 'complete',
      #   'volume_check' => 'volume_check',
      #   'quant' => 'quant',
      #   'report_required' => 'report'
      # }[@state].tap do |action|
      #   yield action if action.present?
      # end
    end

    def action_button
      {
        'in_progress' => 'Completed selected',
        'volume_check' => 'Volume checked selected',
        'quant' => 'Quanted selected',
        'report_required' => 'Reported selected'
      }[@state].tap do |button|
        yield button if button.present?
      end
    end

  end
end
