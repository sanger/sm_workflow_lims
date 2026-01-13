# frozen_string_literal: true

module ReportPresenter
  # Presenter for creating a new report
  class New
    include SharedBehaviour
    include DeploymentInfo

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
      report.workflow.presence&.name
    end

    def start_date
      report.start_date.presence&.strftime(report.date_format)
    end

    def end_date
      report.end_date.presence&.strftime(report.date_format)
    end
  end
end
