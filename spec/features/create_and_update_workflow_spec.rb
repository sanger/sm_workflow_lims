# frozen_string_literal: true
require 'rails_helper'

feature 'can create workflow', js: true do

  scenario 'can create workflow' do
    create :state, name: 'in_progress'
    visit '/'
    click_on 'Admin'
    find("a", text: "Create a new workflow").click
    within("#add-workflow-modal") do
      fill_in 'Name', with: 'New workflow'
      # find('#hasComment', visible: :all).trigger('click')
      # find('#reportable', visible: :all).trigger('click')
      # find('#multi_team_quant_essential', visible: :all).trigger('click')
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
    create :state, name: 'in_progress'
    create :workflow, name: 'Workflow1'
    create :workflow, name: 'Workflow2'
    visit '/'
    click_on 'Admin'
    first(:link, "Edit").click
    fill_in 'Name', with: 'Workflow2'
    click_on 'Update Workflow'
    expect(page).to have_content("Name has already been taken")
    find('#reportable', visible: :all).first(:xpath, './/..').click
    find('#hasComment', visible: :all).first(:xpath, './/..').click
    click_on 'Update Workflow'
    expect(page).to have_content("The workflow was updated.")
    expect(Workflow.count).to eq 2
  end

end
