# frozen_string_literal: true

require 'rails_helper'

describe 'create complete and report assets within standard flow', js: true do
  let!(:asset_type) { create(:asset_type, name: 'Tube', identifier_type: 'ID') }
  let!(:workflow1) { create(:workflow, name: 'Workflow') }
  let!(:workflow2) { create(:workflow, name: 'Reportable workflow', reportable: true) }
  let!(:in_progress) { create(:state, name: 'in_progress') }
  let!(:volume_check) { create(:state, name: 'volume_check') }
  let!(:quant) { create(:state, name: 'quant') }
  let!(:report_required) { create(:state, name: 'report_required') }
  let!(:completed) { create(:state, name: 'completed') }
  let!(:reported) { create(:state, name: 'reported') }

  it 'can create and complete a non-reportable asset' do
    visit '/'
    click_link 'New Batch'
    click_on 'Tube'
    click_on 'Append to batch'
    expect(page).to have_content "The entry can't be created as the form contains some errors."
    within('div#tube-template') do
      fill_in 'identifier', with: 123
    end
    click_on 'Append to batch'
    expect(page).to have_content 'Asset added to the batch'
    click_on 'Save'
    expect(page).to have_content 'The batch provided contains some errors'
    fill_in 'Study', with: 'STDY'
    select('Workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content 'The batch was created.'
    click_on 'In Progress'
    expect(page).to have_selector('table tr', count: 2)
    check "assets[#{Asset.first.id}]"
    click_on 'Completed selected'
    expect(page).to have_content 'In progress is done for 123'
    expect(page).not_to have_selector('table tr')
    click_on 'Volume check'
    expect(page).not_to have_selector('table tr')
    click_on 'Quant'
    expect(page).not_to have_selector('table tr')
    click_on 'Report Required'
    expect(page).not_to have_selector('table tr')
  end

  it 'can create, complete and report a reportable asset' do
    visit '/'
    click_link 'New Batch'
    click_on 'Tube'
    within('div#tube-template') do
      fill_in 'identifier', with: 123
    end
    click_on 'Append to batch'
    expect(page).to have_content 'Asset added to the batch'
    within('div#tube-template') do
      fill_in 'identifier', with: 456
    end
    click_on 'Append to batch'
    within('div#tube-template') do
      fill_in 'identifier', with: 789
    end
    click_on 'Append to batch'
    expect(page).to have_content 'Asset added to the batch'
    fill_in 'Study', with: 'STDY'
    select('Reportable workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content 'The batch was created.'
    click_on 'In Progress'
    expect(page).to have_selector('table tr', count: 4)
    check "assets[#{Asset.second.id}]"
    click_on 'Completed selected'
    expect(page).to have_content 'In progress is done for 456'
    expect(page).to have_selector('table tr', count: 3)
    click_on 'Volume check'
    expect(page).not_to have_selector('table tr')
    click_on 'Quant'
    expect(page).not_to have_selector('table tr')
    click_on 'Report Required'
    expect(page).to have_selector('table tr', count: 2)
    check "assets[#{Asset.second.id}]"
    click_on 'Reported selected'
    expect(page).to have_content 'Report required is done for 456'
  end
end
