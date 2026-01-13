# frozen_string_literal: true

module BatchPresenter
  # Presenter for showing a batch
  class Show
    include SharedBehaviour
    include DeploymentInfo

    attr_reader :batch

    def initialize(batch)
      @batch = batch
    end

    delegate :id, to: :batch

    def action
      "/batches/#{id}"
    end

    def each_asset
      batch.assets.each do |asset|
        yield AssetPresenter::Asset.new(asset)
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
      @workflow ||= first_asset.presence&.workflow || ''
    end

    def prohibited_workflow(reportable, qc_flow, cherrypick_flow)
      return if workflow.blank?

      (workflow.reportable != reportable) ||
        (workflow.qc_flow != qc_flow) ||
        (workflow.cherrypick_flow != cherrypick_flow)
    end

    def workflow_name
      workflow.presence&.name
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
      return first_asset.comment.comment if first_asset&.comment

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
