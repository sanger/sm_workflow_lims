# frozen_string_literal: true

require 'rails_helper'

describe 'search assets and batches', js: true do
  let!(:batch1) { create(:batch_with_assets) }
  let!(:batch2) { create(:batch_with_assets) }
  let!(:additional_asset1) { create(:asset, identifier: batch1.id) }
  let!(:additional_asset2) { create(:asset, identifier: 'Identifier') }
  let!(:search_string) { batch1.id.to_s }

  it 'can create and edit a batch' do
    visit '/'
    fill_in 'Search', with: search_string
    click_on 'search'
    expect(page).to have_content "Search results where batch id or asset identifier matches '#{search_string}'"
    expect(page.all('tbody>tr').count).to eq batch1.assets.count + 1
    fill_in 'Search', with: 'Empty'
    click_on 'search'
    expect(page).to have_content "Search results where batch id or asset identifier matches 'Empty'"
    expect(page.all('tbody>tr').count).to eq 0
    fill_in 'Search', with: 'Identifier'
    click_on 'search'
    expect(page).to have_content "Search results where batch id or asset identifier matches 'Identifier'"
    expect(page.all('tbody>tr').count).to eq 1
    fill_in 'Search', with: batch2.id
    click_on 'search'
    expect(page).to have_content "Search results where batch id or asset identifier matches '#{batch2.id}'"
    expect(page.all('tbody>tr').count).to eq batch2.assets.count
  end
end
