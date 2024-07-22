module ReportPresenter
  # Presenter for showing a report
  class Show
    include SharedBehaviour
    include DeploymentInfo
    attr_reader :report

    def initialize(report)
      @report = report
    end

    def page
      :'reports/show'
    end

    def flash; end

    delegate :title, to: :report

    def column_names
      "<th class='text-center'>#{report.column_names.map(&:humanize).join("</th><th class='text-center'>")}</th>"
    end

    def rows
      ''.tap do |html|
        report.rows.each_with_index do |row, index|
          html_for_row = '<tr>' \
                         "<td class='text-center'> #{index + 1} </td>" \
                         "<td class='text-center'>" +
                         row.data_for(report.column_names).join("</td><td class='text-center'>") +
                         '</td>' \
                         '</tr>'
          html << html_for_row
        end
      end
    end
  end
end
