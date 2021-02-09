require 'rails_helper'

describe Report do
  context 'with invalid parameters' do
    it 'is not valid if workflow, start or end dates are not provided' do
      report = Report.new({})
      expect(report.valid?).to be false
      expect(report.errors.full_messages.count).to eq 3
    end

    it 'is not valid if start date is later than end date' do
      report = Report.new({ start_date: '15/04/2017', end_date: '01/04/2017' })
      expect(report.valid?).to be false
      expect(report.errors.full_messages).to include('Start date should be earlier than the end date.')
    end
  end

  context 'with valid parameters' do
    let!(:workflow) { create(:workflow, name: 'Workflow') }
    let!(:in_progress) { create :state, name: 'in_progress' }
    let!(:completed) { create :state, name: 'completed' }
    let(:asset1) { create :asset, workflow: workflow, study: 'Study1', project: 'Project1' }
    let(:asset2) { create :asset, workflow: workflow, study: 'Study1', project: 'Project2' }
    let(:asset3) { create :asset, workflow: workflow, study: 'Study1', project: 'Project2' }

    before do
      Timecop.freeze(Time.local(2017, 4, 7))
    end

    after do
      Timecop.return
    end

    it 'is valid if workflow, start and end dates are provided' do
      report = Report.new(workflow: workflow, start_date: '01/04/2017', end_date: '15/04/2017')
      expect(report.valid?).to be true
    end

    it 'creates the right csv' do
      asset1.complete
      asset2.complete
      asset3.complete
      asset4 = create :asset, workflow: workflow
      report = Report.new(workflow: workflow, start_date: '01/04/2017', end_date: '15/04/2017')
      expect(report.to_csv).to eq "Report for 'Workflow' workflow from 01/04/2017 to 15/04/2017\nStudy,Project,Cost code name,Assets count\nStudy1,Project1,Not defined,1\nStudy1,Project2,Not defined,2\n"
    end
  end
end
