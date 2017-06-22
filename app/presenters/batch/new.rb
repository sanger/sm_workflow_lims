require './app/presenters/presenter'

module Presenter::BatchPresenter
  class New < Presenter

    def each_asset

    end

    def study
      ''
    end

    def project
      ''
    end

    def workflow
    end

    def pipeline_destination
      'None'
    end

    def cost_code
      ''
    end

    def action
      "/batches"
    end

    def comment
      ''
    end

    def show_completed?
      false
    end

    def num_assets
      1
    end

    def placeholder_date
      'Today'
    end

    def prohibited_workflow(_reportable, _humanized_team_name)
    end

    def workflow_name
      ''
    end

  end
end
