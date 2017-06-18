class Presenter

  module DeploymentInfo

    begin
      require './lib/deployed_version'
    rescue LoadError
        module Deployed
          VERSION_ID = 'LOCAL'
          VERSION_STRING = "Sample Management Workflow Lims LOCAL [#{ENV['RACK_ENV']}]"
        end
    end

    def version_information
      # Provides a quick means of checking the deployed version
      Deployed::VERSION_STRING
    end
  end
  include DeploymentInfo

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

    def each_cost_code
      CostCode.all.each do |cost_code|
        yield cost_code.name, cost_code.id
      end
    end

    def teams
      @teams ||= Team.all
    end

  end
  include SharedBehaviour

end
