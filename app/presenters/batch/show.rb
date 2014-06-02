require './app/presenters/presenter'
require './app/presenters/asset/asset'

class Presenter::BatchPresenter
  class Show < Presenter
    attr_reader :batch

    def initialize(batch)
      @batch=batch
    end

    def id
      batch.id
    end

    def each_asset
      batch.assets.each do |asset|
        yield Presenter::AssetPresenter::Asset.new(asset)
      end
    end

    def study
      return first_asset.study if first_asset
      'Not Applicable'
    end

    def workflow
      return first_asset.workflow.name if first_asset
      'None'
    end

    def comment
      return first_asset.comment.comment if first_asset && first_asset.comment
      ''
    end

    def first_asset
      batch.assets.first
    end

  end
end
