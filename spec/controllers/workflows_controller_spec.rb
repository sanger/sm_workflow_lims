require 'spec_helper'
require './app/controllers/workflows_controller'

describe WorkflowsController do

  let(:mocked_lookups) {
    Workflow.stub(:find_by_id).
        with(3).
        and_return('wf')
  }

  context "show" do
    let(:request) { WorkflowsController.new(params).get}

    context "with a workflow specified" do
      let(:params) {{:workflow_id=>1}}

      it "should look up the appropriate workflow" do
        Workflow.should_receive(:find_by_id).with(1) { 'workflow' }
        request
      end

      it "should pass the workflow to the presenter" do
        Workflow.stub(:find_by_id) { 'workflow' }
        Presenter::WorkflowPresenter::Show.should_receive(:new).with('workflow')
        request
      end

      it "should return the show workflow presenter" do
        Workflow.stub(:find_by_id) { 'workflow' }
        request.should be_an_instance_of(Presenter::WorkflowPresenter::Show)
      end
    end

    context "without a workflow specified" do
      let(:params) {{}}
      it "should require an id parameter" do
        expect { request }.to raise_error(Controller::ParameterError,'You must specify a workflow.')
      end
    end
  end

  context "create" do

    let(:request) { WorkflowsController.new(params).post }

    context "with full parameters" do

      let(:params)  { {
        :name => 'Test',
        :hasComment => true,
        :turn_around_days => "30"
      } }


      it "should pass the options to a workflow creator" do

        mocked_lookups

        Workflow::Creator.should_receive(:create!).
          with(
            name: 'Test',
            has_comment: true,
            reportable: false,
            multi_team_quant_essential: false,
            turn_around_days: "30"
          )

        request
      end

    end


    context "with missing name" do
      let(:params)  { {
        :hasComment => true
      } }
      it "should require a name" do
        expect { request }.to raise_error(Controller::ParameterError,'You must specify a name.')
      end
    end

  end

  context "update" do

    let(:request) { WorkflowsController.new(params).put }

    context "with full parameters" do

      let(:params)  { {:workflow_id=>3,:name=>'New Name',hasComment:true,turn_around_days:'30' } }

      it "should pass the options to a workflow updater" do
        mocked_lookups
        Workflow::Updater.should_receive(:create!).with(
          workflow: 'wf',
          name: 'New Name',
          has_comment: true,
          reportable: false,
          turn_around_days: 30
        )
        request
      end
    end

    context "with missing name" do
      let(:params)  { {:workflow_id=>3,hasComment:true }  }
      it "should require a name" do
        expect { request }.to raise_error(Controller::ParameterError,'You must specify a name.')
      end
    end
  end

  context "index" do
    it "should raise an exception" do
      expect { WorkflowsController.new({}).get_index}.to raise_error(Controller::NotImplimented)
    end
  end

end

