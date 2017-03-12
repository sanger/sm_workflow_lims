# frozen_string_literal: true
require 'spec_helper'

feature 'create complete and report assets within multi team flow', js: true do

  let!(:asset_type) { create(:asset_type, name: 'Tube', identifier_type: 'ID') }
  let!(:workflow1) { create(:workflow, name: 'Multi team workflow') }
  let!(:workflow2) { create(:workflow_with_report, name: 'Reportable multi team workflow') }

  scenario 'can create and complete a non-reportable asset' do
    visit '/'
    click_link 'New Batch'
    click_on 'Tube'
    within("div#tube-template") do
      fill_in 'identifier', with: 123
    end
    click_on 'Append to batch'
    within("div#tube-template") do
      fill_in 'identifier', with: 456
    end
    click_on 'Append to batch'
    expect(page).to have_content "Asset added to the batch"
    fill_in 'Study', with: 'STDY'
    select('Multi team workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content "The batch was created."
    click_on 'In Progress'
    expect(page).not_to have_selector('table tr')
    click_on 'Volume check'
    expect(page).to have_selector('table tr', count: 3)
    check 'update[1]'
    click_on 'Volume checked selected'
    expect(page).to have_content "Volume check step is done for 123"
    expect(page).to have_selector('table tr', count: 2)
    click_on 'Quant'
    expect(page).to have_selector('table tr', count: 2)
    check 'update[1]'
    click_on 'Quanted selected'
    expect(page).to have_content "Quant step is done for 123"
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
    select('Reportable multi team workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content "The batch was created."
    click_on 'In Progress'
    expect(page).not_to have_selector('table tr')
    click_on 'Volume check'
    expect(page).to have_selector('table tr', count: 4)
    check 'update[1]'
    check 'update[3]'
    click_on 'Volume checked selected'
    expect(page).to have_content "Volume check step is done for 123 and 789"
    expect(page).to have_selector('table tr', count: 2)
    click_on 'Quant'
    expect(page).to have_selector('table tr', count: 3)
    check 'update[3]'
    click_on 'Quanted selected'
    expect(page).to have_content "Quant step is done for 789"
    expect(page).to have_selector('table tr', count: 2)
    click_on 'Report Required'
    expect(page).to have_selector('table tr', count: 2)
    check 'update[3]'
    click_on 'Reported selected'
    expect(page).to have_content "Report required step is done for 789"
    expect(page).not_to have_selector('table tr')
  end

end