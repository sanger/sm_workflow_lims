require './app/presenters/presenter'

class Presenter::BatchPresenter
  class New < Presenter

    def each_asset

    end

    def study
      ''
    end

    def workflow
      'None'
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
  end
end
