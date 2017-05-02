class ReportsController < ApplicationController

  def new
    @presenter = Presenter::ReportPresenter::New.new
  end

  def create
    report = Report.new(params)
    if report.valid?
      @presenter = Presenter::ReportPresenter::Show.new(report)
    else
      @presenter = Presenter::ReportPresenter::New.new(report)
      flash[:error] = @presenter.flash
    end
  end

  def csv
    send_data params[:csv_file_content],
              type: 'text/csv',
              filename: "report.csv",
              disposition: 'attachment'
  end

end