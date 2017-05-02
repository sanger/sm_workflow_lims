require './app/presenters/presenter'

module Presenter::WorkflowPresenter

  class Show < Presenter

    attr_reader :workflow

    def initialize(workflow)
      @workflow = workflow
    end

    delegate :name, :has_comment, :reportable, :multi_team_quant_essential, to: :workflow

    def turn_around
      workflow.turn_around_days
    end

    def action
      "/admin/workflows/#{workflow.id}"
    end

  end

end
