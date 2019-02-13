require 'rails_helper'
require './app/presenters/report/show'
require './spec/presenters/shared_presenter_behaviour'

describe Presenter::ReportPresenter::Show do
  let(:workflow) { build(:workflow, name: "Workflow") }
  let!(:report) { Report.new(workflow: workflow, start_date: "01/04/2017", end_date: "15/04/2017")}
  let!(:completed) { create :state, name: 'completed' }
  let(:asset1) { create :asset, workflow: workflow, study: 'Study1', project: 'Project1' }
  let(:asset2) { create :asset, workflow: workflow, study: 'Study1', project: 'Project2', cost_code: (create :cost_code, name: 'A1') }
  let(:presenter) { Presenter::ReportPresenter::Show.new(report) }

  context "always" do
    include_examples("shared presenter behaviour")
  end

  it 'should generte correct html for report' do
    Timecop.freeze(Time.local(2017, 4, 7))
    asset1.complete
    asset2.complete
    expect(presenter.title).to eq "Report for 'Workflow' workflow from 01/04/2017 to 15/04/2017"
    expect(presenter.column_names).to eq "<th class='text-center'>Study</th>" +
                                          "<th class='text-center'>Project</th>" +
                                          "<th class='text-center'>Cost code name</th>" +
                                          "<th class='text-center'>Assets count</th>"
    expect(presenter.rows).to eq "<tr>"+
                                    "<td class='text-center'> 1 </td>" +
                                    "<td class='text-center'>Study1</td>" +
                                    "<td class='text-center'>Project1</td>" +
                                    "<td class='text-center'>Not defined</td>" +
                                    "<td class='text-center'>1</td>" +
                                  "</tr>" +
                                  "<tr>" +
                                    "<td class='text-center'> 2 </td>" +
                                    "<td class='text-center'>Study1</td>" +
                                    "<td class='text-center'>Project2</td>" +
                                    "<td class='text-center'>A1</td>" +
                                    "<td class='text-center'>1</td>" +
                                  "</tr>"
    expect(presenter.flash).to be nil
    expect(presenter.page).to eq :'reports/show'
    Timecop.return
  end

end
