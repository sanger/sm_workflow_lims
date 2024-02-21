# frozen_string_literal: true

require 'rails_helper'

describe 'create complete and report assets within QC flow', :js do
  let!(:asset_type) { create(:asset_type, name: 'Tube', identifier_type: 'ID') }
  let!(:in_progress) { create(:state, name: 'in_progress') }
  let!(:volume_check) { create(:state, name: 'volume_check') }
  let!(:quant) { create(:state, name: 'quant') }
  let!(:report_required) { create(:state, name: 'report_required') }
  let!(:completed) { create(:state, name: 'completed') }
  let!(:reported) { create(:state, name: 'reported') }
  let!(:workflow_first) { create(:qc_workflow, name: 'QC workflow') }
  let!(:workflow_second) { create(:qc_workflow, name: 'Reportable QC workflow', reportable: true) }

  it 'can create and complete a non-reportable asset' do
    visit '/'
    click_on 'New Batch'
    click_on 'Tube'
    within('div#tube-template') do
      fill_in 'identifier', with: 123
    end
    click_on 'Append to batch'
    within('div#tube-template') do
      fill_in 'identifier', with: 456
    end
    click_on 'Append to batch'
    expect(page).to have_content 'Asset added to the batch'
    fill_in 'Study', with: 'STDY'
    select('QC workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content 'The batch was created.'
    click_on 'In Progress'
    expect(page).to have_no_css('table tr')
    click_on 'Volume check'
    expect(page).to have_css('table tr', count: 3)
    check "assets[#{Asset.first.id}]"
    click_on 'Volume checked selected'
    expect(page).to have_content 'Volume check is done for 123'
    expect(page).to have_css('table tr', count: 2)
    click_on 'Quant'
    expect(page).to have_css('table tr', count: 2)
    check "assets[#{Asset.first.id}]"
    click_on 'Completed selected'
    expect(page).to have_content 'Quant is done for 123'
    expect(page).to have_no_css('table tr')
    click_on 'Report Required'
    expect(page).to have_no_css('table tr')
  end

  it 'can create, complete and report a reportable asset' do
    visit '/'
    click_on 'New Batch'
    click_on 'Tube'
    within('div#tube-template') do
      fill_in 'identifier', with: 123
    end
    click_on 'Append to batch'
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
    select('Reportable QC workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content 'The batch was created.'
    click_on 'In Progress'
    expect(page).to have_no_css('table tr')
    click_on 'Volume check'
    expect(page).to have_css('table tr', count: 4)
    check "assets[#{Asset.first.id}]"
    check "assets[#{Asset.third.id}]"
    click_on 'Volume checked selected'
    expect(page).to have_content 'Volume check is done for 123 and 789'
    expect(page).to have_css('table tr', count: 2)
    click_on 'Quant'
    expect(page).to have_css('table tr', count: 3)
    check "assets[#{Asset.third.id}]"
    click_on 'Completed selected'
    expect(page).to have_content 'Quant is done for 789'
    expect(page).to have_css('table tr', count: 2)
    click_on 'Report Required'
    expect(page).to have_css('table tr', count: 2)
    check "assets[#{Asset.third.id}]"
    click_on 'Reported selected'
    expect(page).to have_content 'Report required is done for 789'
    expect(page).to have_no_css('table tr')
  end
end
