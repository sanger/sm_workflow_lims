# frozen_string_literal: true

module WorkflowPresenter
  # Presenter for showing a workflow
  class Show
    include SharedBehaviour
    include DeploymentInfo

    attr_reader :workflow

    def initialize(workflow)
      @workflow = workflow
    end

    delegate :name, :has_comment, :reportable, :qc_flow, :cherrypick_flow, :active, to: :workflow

    def turn_around
      workflow.turn_around_days
    end

    def action
      "/admin/workflows/#{workflow.id}"
    end
  end
end
