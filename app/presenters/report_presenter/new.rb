# frozen_string_literal: true

module Presenters
  module ReportPresenter
    # Presenter for creating a new report
    class New < Presenter
      attr_reader :report

      def initialize(report = Report.new({}))
        @report = report
      end

      def action
        '/reports'
      end

      def page
        :'reports/new'
      end

      def flash
        report.errors.full_messages.join(', ') if report.errors.present?
      end

      def workflow
        report.workflow.name if report.workflow.present?
      end

      def start_date
        report.start_date.strftime(report.date_format) if report.start_date.present?
      end

      def end_date
        report.end_date.strftime(report.date_format) if report.end_date.present?
      end
    end
  end
end
