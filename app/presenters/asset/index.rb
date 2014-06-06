require './app/presenters/presenter'
require './app/presenters/asset/asset'

module Presenter::AssetPresenter
  class Index < Presenter

    attr_reader :search, :assets, :total

    def initialize(found_assets,search=nil)
      @total  = found_assets.count
      @assets = found_assets.group_by {|a| a.asset_type.name}.tap {|h| h.default = [] }
      @search = search
    end

    def asset_identifiers
      assets.values.flatten.map(&:identifier)
    end

    def has_assets?(type)
      return assets[type].length > 0
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

  end
end
