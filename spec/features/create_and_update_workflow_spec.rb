# frozen_string_literal: true
require 'rails_helper'

feature 'can create workflow', js: true do

  scenario 'can create workflow' do
    create :state, name: 'in_progress'
    create :state, name: 'cherrypick'
    visit '/'
    click_on 'Admin'
    find("a", text: "Create a new workflow").click
    within("#add-workflow-modal") do
      fill_in 'Name', with: 'New workflow'
      find('#active', visible: :all).first(:xpath, './/..').click
      find('#reportable', visible: :all).first(:xpath, './/..').click
      find('#hasComment', visible: :all).first(:xpath, './/..').click
      find('#qcFlow', visible: :all).first(:xpath, './/..').click
      find('#cherrypickFlow', visible: :all).first(:xpath, './/..').click
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
    created_workflow = Workflow.find_by(name: 'New Workflow')
    expect(created_workflow.active).to be_truthy
    expect(created_workflow.reportable).to be_truthy
    expect(created_workflow.has_comment).to be_truthy
    expect(created_workflow.qc_flow).to be_truthy
    expect(created_workflow.cherrypick_flow).to be_truthy
    expect(created_workflow.initial_state.name).to eq('cherrypick')
  end

  scenario 'can update workflow' do
    create :state, name: 'in_progress'
    create :state, name: 'cherrypick'
    create :workflow, name: 'Workflow1'
    create :workflow, name: 'Workflow2'
    visit '/'
    click_on 'Admin'
    first(:link, "Edit").click
    fill_in 'Name', with: 'Workflow2'
    click_on 'Update Workflow'
    expect(page).to have_content("Name has already been taken")
    find('#active', visible: :all).first(:xpath, './/..').click
    find('#reportable', visible: :all).first(:xpath, './/..').click
    find('#hasComment', visible: :all).first(:xpath, './/..').click
    find('#qcFlow', visible: :all).first(:xpath, './/..').click
    find('#cherrypickFlow', visible: :all).first(:xpath, './/..').click
    click_on 'Update Workflow'
    expect(page).to have_content("The workflow was updated.")
    expect(Workflow.count).to eq 2
    updated_workflow = Workflow.find_by(name: 'Workflow1')
    expect(updated_workflow.active).to be_falsey
    expect(updated_workflow.reportable).to be_truthy
    expect(updated_workflow.has_comment).to be_truthy
    expect(updated_workflow.qc_flow).to be_truthy
    expect(updated_workflow.cherrypick_flow).to be_truthy
    expect(updated_workflow.initial_state.name).to eq('cherrypick')
  end

end
