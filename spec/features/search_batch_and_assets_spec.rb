# frozen_string_literal: true

require 'rails_helper'

describe 'search assets and batches', :js do
  let!(:batch_first) { create(:batch_with_assets) }
  let!(:batch_second) { create(:batch_with_assets) }
  let!(:additional_asset_first) { create(:asset, identifier: batch_first.id) }
  let!(:additional_asset_second) { create(:asset, identifier: 'Identifier') }
  let!(:search_string) { batch_first.id.to_s }

  it 'can create and edit a batch' do
    visit '/'
    fill_in 'Search', with: search_string
    click_on 'search'
    expect(page).to have_content "Search results where batch id or asset identifier matches '#{search_string}'"
    expect(page.all('tbody>tr').count).to eq batch_first.assets.count + 1
    fill_in 'Search', with: 'Empty'
    click_on 'search'
    expect(page).to have_content "Search results where batch id or asset identifier matches 'Empty'"
    expect(page.all('tbody>tr').count).to eq 0
    fill_in 'Search', with: 'Identifier'
    click_on 'search'
    expect(page).to have_content "Search results where batch id or asset identifier matches 'Identifier'"
    expect(page.all('tbody>tr').count).to eq 1
    fill_in 'Search', with: batch_second.id
    click_on 'search'
    expect(page).to have_content "Search results where batch id or asset identifier matches '#{batch_second.id}'"
    expect(page.all('tbody>tr').count).to eq batch_second.assets.count
  end
end
