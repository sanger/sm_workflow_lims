# frozen_string_literal: true

require 'rails_helper'

describe 'can generate report', :js do
  let!(:workflow_first) { create(:workflow, name: 'Workflow_first') }
  let!(:workflow_second) { create(:workflow, name: 'Workflow_second') }
  let!(:in_progress) { create(:state, name: 'in_progress') }
  let!(:completed) { create(:state, name: 'completed') }
  let!(:asset_first) { create(:asset, workflow: workflow_first, study: 'Study1', project: 'Project1') }
  let!(:asset_second) do
    create(:asset, workflow: workflow_first, study: 'Study1', project: 'Project2',
                   cost_code: create(:cost_code, name: 'A1'))
  end
  let!(:asset_third) { create(:asset, workflow: workflow_second, study: 'Study1', project: 'Project2') }
  let!(:asset_fourth) { create(:asset, workflow: workflow_first) }

  before do
    Timecop.freeze(Time.local(2017, 3, 7))
  end

  after do
    Timecop.return
  end

  it 'can generate report' do
    asset_first.complete
    asset_second.complete
    asset_third.complete
    visit '/'
    click_on 'Admin'
    click_on 'Create a new report'
    select('Workflow_first', from: 'Workflow')
    fill_in('start_date', with: '31/03/2017').send_keys(:escape)
    fill_in('end_date', with: '01/03/2017').send_keys(:escape)
    click_on(text: 'Create report')
    expect(page).to have_content('Start date should be earlier than the end date.')

    fill_in('start_date', with: '01/03/2017').send_keys(:escape)
    fill_in('end_date', with: '31/03/2017').send_keys(:escape)
    click_on(text: 'Create report')
    expect(page).to have_content("Report for 'Workflow_first' workflow from 01/03/2017 to 31/03/2017")
    within('table#report') do
      expect(page).to have_xpath('.//tr', count: 3)
      expect(page).to have_text('Study Project Cost code name Assets count')
      expect(page).to have_text('1 Study1 Project1 Not defined 1')
      expect(page).to have_text('2 Study1 Project2 A1 1')
    end

    click_on 'Download csv file'
  end
end
