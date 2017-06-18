require './app/presenters/presenter'
require './app/presenters/asset/asset'

module Presenter::BatchPresenter
  class Show < Presenter
    attr_reader :batch

    def initialize(batch)
      @batch=batch
    end

    def id
      batch.id
    end

    def action
      "/batches/#{id}"
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

    def project
      return first_asset.project if first_asset
      'Not Applicable'
    end

    def workflow
      @workflow ||= (first_asset.workflow if first_asset.present?) || ''
    end

    def prohibited_workflow(reportable, humanized_team_name)
      if workflow.present?
        (workflow.reportable != reportable) || (workflow.humanized_team_name != humanized_team_name)
      end
    end

    def workflow_name
      if workflow.present?
        workflow.name
      end
    end

    def pipeline_destination
      return first_asset.pipeline_destination.name if first_asset && !first_asset.pipeline_destination.nil?
      'None'
    end

    def cost_code
      return first_asset.cost_code.name if first_asset && !first_asset.cost_code.nil?
      ''
    end

    def comment
      return first_asset.comment.comment if first_asset && first_asset.comment
      ''
    end

    def show_completed?
      true
    end

    def first_asset
      batch.assets.first
    end

    def num_assets
      batch.assets.count
    end


    def placeholder_date
      first_asset.begun_at.strftime('%d/%m/%Y')
    end

  end
end
