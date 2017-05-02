require './app/controllers/controller'
require './app/models/report'
require './app/presenters/report/show'
require './app/presenters/report/new'

class ReportsController < Controller

  def new
    Presenter::ReportPresenter::New.new
  end

  def create
    report = Report.new(params)
    if report.valid?
      Presenter::ReportPresenter::Show.new(report)
    else
      Presenter::ReportPresenter::New.new(report)
    end
  end

  def csv
  end

end