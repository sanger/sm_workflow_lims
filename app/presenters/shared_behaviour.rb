# module Presenters
  module SharedBehaviour

    def each_asset_type
      AssetType.find_each do |asset_type|
        yield(asset_type.name,
              asset_type.identifier_type,
              asset_type.has_sample_count,
              asset_type.id)
      end
    end

    def with_each_asset_type
      AssetType.find_each do |asset_type|
        yield(AssetTypePresenter::AssetType.new(asset_type))
      end
    end

    def each_workflow
      Workflow.includes(:initial_state).order(active: :desc).each do |workflow|
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
      Workflow.where(active: true).includes(:initial_state).find_each do |workflow|
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
      PipelineDestination.find_each do |pipeline_destination|
        yield pipeline_destination.name, pipeline_destination.id
      end
    end

    def each_cost_code
      CostCode.find_each do |cost_code|
        yield cost_code.name, cost_code.id
      end
    end
  end
# end
