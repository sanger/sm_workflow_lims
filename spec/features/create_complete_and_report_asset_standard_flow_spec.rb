# frozen_string_literal: true
require 'spec_helper'

feature 'create complete and report assets within standard flow', js: true do

  let!(:asset_type) { create(:asset_type, name: 'Tube', identifier_type: 'ID') }
  let!(:workflow1) { create(:workflow, name: 'Workflow') }
  let!(:workflow2) { create(:workflow_with_report, name: 'Reportable workflow') }

  scenario 'can create and complete a non-reportable asset' do
    visit '/'
    click_link 'New Batch'
    click_on 'Tube'
    click_on 'Append to batch'
    expect(page).to have_content "The entry can't be created as the form contains some errors."
    within("div#tube-template") do
      fill_in 'identifier', with: 123
    end
    click_on 'Append to batch'
    expect(page).to have_content "Asset added to the batch"
    fill_in 'Study', with: 'STDY'
    select('Workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content "The batch was created."
    click_on 'In Progress'
    expect(page).to have_selector('table tr', count: 2)
    check 'update[1]'
    click_on 'Completed selected'
    expect(page).to have_content "In progress step is done for 123"
    expect(page).not_to have_selector('table tr')
    click_on 'Volume check'
    expect(page).not_to have_selector('table tr')
    click_on 'Quant'
    expect(page).not_to have_selector('table tr')
    click_on 'Report Required'
    expect(page).not_to have_selector('table tr')
  end

  scenario 'can create, complete and report a reportable asset' do
    visit '/'
    click_link 'New Batch'
    click_on 'Tube'
    within("div#tube-template") do
      fill_in 'identifier', with: 123
    end
    click_on 'Append to batch'
    expect(page).to have_content "Asset added to the batch"
    within("div#tube-template") do
      fill_in 'identifier', with: 456
    end
    click_on 'Append to batch'
    within("div#tube-template") do
      fill_in 'identifier', with: 789
    end
    click_on 'Append to batch'
    expect(page).to have_content "Asset added to the batch"
    fill_in 'Study', with: 'STDY'
    select('Reportable workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content "The batch was created."
    click_on 'In Progress'
    expect(page).to have_selector('table tr', count: 4)
    check 'update[2]'
    click_on 'Completed selected'
    expect(page).to have_content "In progress step is done for 456"
    expect(page).to have_selector('table tr', count: 3)
    click_on 'Volume check'
    expect(page).not_to have_selector('table tr')
    click_on 'Quant'
    expect(page).not_to have_selector('table tr')
    click_on 'Report Required'
    expect(page).to have_selector('table tr', count: 2)
    check 'update[2]'
    click_on 'Reported selected'
    expect(page).to have_content "Report required step is done for 456"
  end

end