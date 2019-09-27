class Presenter

  module DeploymentInfo
    require './lib/deployed_version'

    def version_information
      # Provides a quick means of checking the deployed version
      Deployed::VERSION_STRING
    end

    def commit_information
      Deployed::VERSION_COMMIT
    end

    def repo_url
      Deployed::REPO_URL
    end

    def host_name
      Deployed::HOSTNAME
    end

    def release_name
      Deployed::RELEASE_NAME
    end
  end
  include DeploymentInfo

  module SharedBehaviour

    require './app/presenters/asset_type/asset_type'

    def each_asset_type
      AssetType.all.each do |asset_type|
        yield(asset_type.name,
              asset_type.identifier_type,
              asset_type.has_sample_count,
              asset_type.id)
      end
    end

    def with_each_asset_type
      AssetType.all.each do |asset_type|
        yield(Presenter::AssetTypePresenter::AssetType.new(asset_type))
      end
    end

    def each_workflow
      Workflow.all.includes(:initial_state).order(active: :desc).each do |workflow|
        yield(workflow.name,
              workflow.has_comment,
              workflow.id,
              workflow.reportable,
              workflow.qc_flow,
              workflow.turn_around_days,
              workflow.active,
              workflow.cherrypick_flow)
      end
    end

    def active_workflows
      Workflow.where(active: true).includes(:initial_state).each do |workflow|
        yield(workflow.name,
              workflow.has_comment,
              workflow.id,
              workflow.reportable,
              workflow.qc_flow,
              workflow.cherrypick_flow,
              workflow.turn_around_days,
              workflow.active)
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

  end
  include SharedBehaviour

end
