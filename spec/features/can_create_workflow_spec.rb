# frozen_string_literal: true
require 'spec_helper'

feature 'can create workflow', js: true do

  scenario 'can create workflow' do
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
  end

end