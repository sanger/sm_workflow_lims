require 'spec_helper'
require './app/models/workflow'

describe Workflow::Updater do

  # Workflow::Updater.should_receive(:create!).with(
  #   workflow: 'wf',
  #   name: 'New Name',
  #   has_comment: true,
  #   reportable: false
  # )

  let(:new_name)        { 'New Name' }
  let(:new_has_comment) { true       }
  let(:new_reportable)  { false      }
  let(:new_turn_around) { 5 }

  let(:mock_workflow)   { double('workflow').tap do |wf|

    wf.should_receive(:update_attributes!).
      with(
        name: new_name,
        has_comment: new_has_comment,
        reportable: new_reportable
      )

    end
  }

  it "should update the workflow with the new parameters" do
    Workflow::Updater.create!(
      workflow: mock_workflow,
      name: new_name,
      has_comment: new_has_comment,
      reportable: new_reportable
    )
  end

end
