class Presenter

  module SharedBehaviour

    require './app/presenters/asset_type/asset_type'

    def each_asset_type
      AssetType.all.each do |asset_type|
        yield(asset_type.name,asset_type.identifier_type,asset_type.has_sample_count,asset_type.id)
      end
    end

    def with_each_asset_type
      AssetType.all.each do |asset_type|
        yield(Presenter::AssetTypePresenter::AssetType.new(asset_type))
      end
    end

    def each_workflow
      Workflow.all.includes(:team).each do |workflow|
        yield(workflow.name, workflow.has_comment, workflow.id, workflow.reportable, workflow.humanized_team_name, workflow.turn_around_days)
      end
    end

    def each_pipeline_destination
      PipelineDestination.all.each do |pipeline_destination|
        yield pipeline_destination.name, pipeline_destination.id
      end
    end

    def teams
      @teams ||= Team.all
    end

  end
  include SharedBehaviour

end
