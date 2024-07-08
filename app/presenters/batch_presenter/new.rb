# frozen_string_literal: true

module Presenters
  module BatchPresenter
    # Presenter for creating a new batch
    class New < Presenter
      def each_asset; end

      def study
        ''
      end

      def project
        ''
      end

      def workflow; end

      def pipeline_destination
        'None'
      end

      def cost_code
        ''
      end

      def action
        '/batches'
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

      def prohibited_workflow(_reportable, _qc_flow, _cherrypick_flow); end

      def workflow_name
        ''
      end
    end
  end
end
