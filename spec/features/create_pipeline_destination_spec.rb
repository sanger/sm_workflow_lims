# frozen_string_literal: true

require 'rails_helper'

describe 'can create pipeline destination', :js do
  it 'can create pipeline destination' do
    visit '/'
    click_on 'Admin'
    find('a', text: 'Create a new destination').click
    within('#add-pipeline-destination-modal') do
      fill_in 'Name', with: 'New pipeline destination'
      click_on(text: 'Create')
    end
    expect(page).to have_content('The pipeline destination was created.')
    expect(PipelineDestination.count).to eq 1
    find('a', text: 'Create a new destination').click
    within('#add-pipeline-destination-modal') do
      fill_in 'Name', with: 'New pipeline destination'
      click_on(text: 'Create')
    end
    expect(page).to have_content('Name has already been taken')
    expect(PipelineDestination.count).to eq 1
  end
end
