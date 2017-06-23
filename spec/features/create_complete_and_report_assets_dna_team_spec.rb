# frozen_string_literal: true
require 'rails_helper'

feature 'create complete and report assets within dna team', js: true do

  let!(:asset_type) { create(:asset_type, name: 'Tube', identifier_type: 'ID') }
  let!(:workflow1) { create(:dna_workflow, name: 'Dna workflow') }
  let!(:workflow2) { create(:dna_workflow_reportable, name: 'Reportable dna workflow') }
  let!(:sm_workflow) { create(:workflow, name: 'Workflow') }

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
    select('Dna workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content "The batch was created."
    click_on 'Sample management'
    click_on 'In progress'
    expect(page).not_to have_selector('table tr')
    click_on 'Dna'
    click_on 'Volume check'
    expect(page).to have_selector('table tr', count: 3)
    check "assets[#{Asset.first.id}]"
    click_on 'Mark selected assets as Volume checked'
    expect(page).to have_content "Volume check is done for 123"
    expect(page).to have_selector('table tr', count: 2)
    click_on 'Quant'
    expect(page).to have_selector('table tr', count: 2)
    check "assets[#{Asset.first.id}]"
    click_on 'Mark selected assets as completed'
    expect(page).to have_content "Quant is done for 123"
    expect(page).not_to have_selector('table tr')
    click_on 'Report required'
    expect(page).not_to have_selector('table tr')
    click_on 'Sample management'
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
    select('Reportable dna workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content "The batch was created."
    click_on 'Sample management'
    click_on 'In progress'
    expect(page).not_to have_selector('table tr')
    click_on 'Dna'
    click_on 'Volume check'
    expect(page).to have_selector('table tr', count: 4)
    check "assets[#{Asset.first.id}]"
    check "assets[#{Asset.third.id}]"
    click_on 'Mark selected assets as Volume checked'
    expect(page).to have_content "Volume check is done for 123 and 789"
    expect(page).to have_selector('table tr', count: 2)
    click_on 'Quant'
    expect(page).to have_selector('table tr', count: 3)
    check "assets[#{Asset.third.id}]"
    click_on 'Mark selected assets as completed'
    expect(page).to have_content "Quant is done for 789"
    expect(page).to have_selector('table tr', count: 2)
    click_on 'Sample management'
    click_on 'Report required'
    expect(page).not_to have_selector('table tr')
    click_on 'Dna'
    click_on 'Report required'
    expect(page).to have_selector('table tr', count: 2)
    check "assets[#{Asset.third.id}]"
    click_on 'Mark selected assets as reported'
    expect(page).to have_content "Report required is done for 789"
    expect(page).not_to have_selector('table tr')
  end

end