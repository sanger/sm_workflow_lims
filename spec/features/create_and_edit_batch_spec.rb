# frozen_string_literal: true

require 'rails_helper'

describe 'create and edit batch', :js do
  let!(:asset_type) { create(:asset_type, name: 'Sample', identifier_type: 'Name') }
  let!(:workflow_first) { create(:workflow, name: 'Workflow') }
  let!(:workflow_second) { create(:workflow, name: 'Reportable workflow', reportable: true) }
  let!(:workflow_third) { create(:qc_workflow, name: 'QC workflow') }
  let!(:workflow_fourth) { create(:workflow, name: 'Deactivated workflow', active: false) }
  let!(:in_progress) { create(:state, name: 'in_progress') }
  let!(:volume_check) { create(:state, name: 'volume_check') }

  it 'can create and edit a batch' do
    visit '/'
    click_on 'New Batch'
    click_on 'Sample'
    within('div#sample-template') do
      fill_in 'identifier', with: 'sample1 sample2'
    end
    click_on 'Append to batch'
    expect(page).to have_content 'Asset added to the batch'

    fill_in 'Study', with: 'STDY'
    select('Workflow', from: 'Workflow')
    click_on 'Save'
    expect(page).to have_content 'The batch was created.'
    options = page.all('select#workflow_id option')
    expect(options.length).to eq 4
    expect(options[1].text).to include 'Workflow'
    expect(options[1].disabled?).to be false
    expect(options[2].text).to include 'Reportable workflow'
    expect(options[2].disabled?).to be true
    expect(options[3].text).to include 'QC workflow'
    expect(options[3].disabled?).to be true

    fill_in 'Study', with: 'STDY2'
    click_on 'Save'
    expect(page).to have_content 'The batch was updated.'
    Batch.last.assets.each do |asset|
      expect(asset.study).to eq 'STDY2'
    end

    count = Batch.count
    click_on 'Remove'
    click_on 'Accept'
    expect(page).to have_content 'The batch was deleted.'
    expect(Batch.count).to eq count - 1
  end

  it 'can create a batch with an Aker barcode' do
    create(:asset_type, name: 'Plate with Name', identifier_type: 'Name')
    visit '/'
    click_on 'New Batch'
    click_on 'Plate with Name'
    within('div#plate_with_name-template') do
      fill_in 'identifier', with: 'AKER-123'
    end
    click_on 'Append to batch'
    expect(page).to have_content 'Asset added to the batch'
  end
end
