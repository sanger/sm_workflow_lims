# frozen_string_literal: true
require 'rails_helper'

feature 'create complete and report assets within sample management team', js: true do

  let!(:asset_type) { create(:asset_type, name: 'Tube', identifier_type: 'ID') }
  let!(:workflow1) { create(:workflow, name: 'Workflow') }
  let!(:workflow2) { create(:workflow_reportable, name: 'Reportable workflow') }
  let!(:dna_workflow) { create :dna_workflow }

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
    click_on 'Save'
    expect(page).to have_content "The batch provided contains some errors"
    fill_in 'Study', with: 'STDY'
    select('Workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content "The batch was created."
    click_on 'Sample management'
    click_on 'In progress'
    expect(page).to have_selector('table tr', count: 2)
    check "assets[#{Asset.first.id}]"
    click_on 'Mark selected assets as completed'
    expect(page).to have_content "In progress is done for 123"
    expect(page).not_to have_selector('table tr')
    expect(page).not_to have_content 'Volume check'
    expect(page).not_to have_content 'Quant'
    click_on 'Report required'
    expect(page).not_to have_selector('table tr')
    click_on 'Dna'
    click_on 'Volume check'
    expect(page).not_to have_selector('table tr')
    click_on 'Quant'
    expect(page).not_to have_selector('table tr')
    click_on 'Report required'
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
    click_on 'Sample management'
    click_on 'In progress'
    expect(page).to have_selector('table tr', count: 4)
    check "assets[#{Asset.second.id}]"
    click_on 'Mark selected assets as completed'
    expect(page).to have_content "In progress is done for 456"
    expect(page).to have_selector('table tr', count: 3)
    click_on 'Report required'
    expect(page).to have_selector('table tr', count: 2)
    check "assets[#{Asset.second.id}]"
    click_on 'Mark selected assets as reported'
    expect(page).to have_content "Report required is done for 456"
    click_on 'Dna'
    click_on 'Volume check'
    expect(page).not_to have_selector('table tr')
    click_on 'Quant'
    expect(page).not_to have_selector('table tr')
    click_on 'Report required'
    expect(page).not_to have_selector('table tr')
  end

end