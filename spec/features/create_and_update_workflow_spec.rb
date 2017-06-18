# frozen_string_literal: true
require 'rails_helper'

feature 'can create workflow', js: true do

  scenario 'can create workflow' do
    create :sample_management_team
    create :dna_team
    visit '/'
    click_on 'Admin'
    find("a", text: "Create a new workflow").click
    within("#add-workflow-modal") do
      fill_in 'Name', with: 'New workflow'
      # find('#hasComment', visible: :all).trigger('click')
      # find('#reportable', visible: :all).trigger('click')
      # select('Sample management', from: 'team')
      find("button", text: "Create").click
    end
    expect(page).to have_content("The workflow was created.")
    expect(Workflow.count).to eq 1
    find("a", text: "Create a new workflow").click
    within("#add-workflow-modal") do
      fill_in 'Name', with: 'New workflow'
      find("button", text: "Create").click
    end
    expect(page).to have_content("Name has already been taken")
    expect(Workflow.count).to eq 1
  end

  scenario 'can update workflow' do
    create :sample_management_team
    create :dna_team
    create :workflow, name: 'Workflow1'
    create :workflow, name: 'Workflow2'
    visit '/'
    click_on 'Admin'
    first(:link, "Edit").click
    fill_in 'Name', with: 'Workflow2'
    click_on 'Update Workflow'
    expect(page).to have_content("Name has already been taken")
    find('#reportable', visible: :all).trigger('click')
    find('#hasComment', visible: :all).trigger('click')
    select('Dna', from: 'team')
    click_on 'Update Workflow'
    expect(page).to have_content("The workflow was updated.")
    expect(Workflow.count).to eq 2
  end

end