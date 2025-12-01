require 'rails_helper'

describe 'ReportPresenter::New' do
  let(:presenter) { ReportPresenter::New.new }

  context 'always' do
    it_behaves_like('shared presenter behaviour')
  end

  context 'with empty report' do
    it 'does not have report data' do
      expect(presenter.workflow).to be_nil
      expect(presenter.start_date).to be_nil
      expect(presenter.end_date).to be_nil
      expect(presenter.flash).to be_nil
      expect(presenter.action).to eq '/reports'
      expect(presenter.page).to eq :'reports/new'
    end
  end

  context 'with valid report' do
    let!(:workflow) { create(:workflow, name: 'Workflow') }
    let!(:report) { Report.new(workflow:, start_date: '01/04/2017', end_date: '15/04/2017') }
    let(:presenter) { ReportPresenter::New.new(report) }

    it 'has report data' do
      expect(presenter.workflow).to eq 'Workflow'
      expect(presenter.start_date).to eq '01/04/2017'
      expect(presenter.end_date).to eq '15/04/2017'
      expect(presenter.flash).to be_nil
      expect(presenter.action).to eq '/reports'
      expect(presenter.page).to eq :'reports/new'
    end
  end

  context 'with invalid report' do
    let!(:workflow) { create(:workflow, name: 'Workflow') }
    let!(:report) { Report.new(workflow:, start_date: '01/04/2017') }
    let(:presenter) { ReportPresenter::New.new(report) }

    it 'has flash' do
      expect(presenter.report.valid?).to be false
      expect(presenter.workflow).to eq 'Workflow'
      expect(presenter.start_date).to eq '01/04/2017'
      expect(presenter.end_date).to be_nil
      expect(presenter.flash).to eq "End date can't be blank"
    end
  end
end
