require './app/presenters/report/new'
require './app/presenters/report/show'

class ReportsController < ApplicationController
  def show; end

  def new
    @presenter = Presenter::ReportPresenter::New.new
  end

  def create
    report = Report.new(params.permit(:workflow_id, :start_date, :end_date))
    if report.valid?
      @presenter = Presenter::ReportPresenter::Show.new(report)
      render :show
    else
      @presenter = Presenter::ReportPresenter::New.new(report)
      flash[:error] = @presenter.flash
      render :new
    end
  end

  def csv
    send_data params[:csv_file_content],
              type: 'text/csv',
              filename: 'report.csv',
              disposition: 'attachment'
  end
end
