# frozen_string_literal: true
require 'rails_helper'

feature 'can generate report', js: true do

  let!(:workflow1) { create(:workflow, name: 'Workflow1') }
  let!(:workflow2) { create(:workflow, name: 'Workflow2') }
  let!(:in_progress) { create :state, name: 'in_progress' }
  let!(:completed) { create :state, name: 'completed' }
  let!(:asset1) { create :asset, workflow: workflow1, study: 'Study1', project: 'Project1' }
  let!(:asset2) { create :asset, workflow: workflow1, study: 'Study1', project: 'Project2', cost_code: (create :cost_code, name: 'A1') }
  let!(:asset3) { create :asset, workflow: workflow2, study: 'Study1', project: 'Project2' }
  let!(:asset4) { create :asset, workflow: workflow1}

  before do
    Timecop.freeze(Time.local(2017, 3, 7))
  end

  scenario 'can generate report' do
    asset1.create_event(completed)
    asset2.create_event(completed)
    asset3.create_event(completed)
    visit '/'
    click_on 'Admin'
    click_on 'Create a new report'
    select('Workflow1', from: 'Workflow')
    fill_in 'start_date', with: '31/03/2017'
    fill_in 'end_date', with: '01/03/2017'
    find("button", text: "Create report").trigger('click')
    expect(page).to have_content("Start date should be earlier than the end date.")
    fill_in 'start_date', with: '01/03/2017'
    fill_in 'end_date', with: '31/03/2017'
    find("button", text: "Create report").trigger('click')
    expect(page).to have_content("Report for 'Workflow1' workflow from 01/03/2017 to 31/03/2017")
    within('table#report') do
      expect(page).to have_xpath(".//tr", count: 3)
      expect(page).to have_text("Study Project Cost code name Assets count")
      expect(page).to have_text("1 Study1 Project1 Not defined 1")
      expect(page).to have_text("2 Study1 Project2 A1 1")
    end
    click_on 'Download csv file'
  end

  after do
    Timecop.return
  end

end