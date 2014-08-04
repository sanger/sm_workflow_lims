require 'spec_helper'
require './app/controllers/batches_controller'
require './app/models/batch'
require './app/models/workflow'
require './app/models/asset_type'

describe BatchesController do

  let(:mocked_lookups) {
      Workflow.stub(:find_by_id).
        with(3).
        and_return('wf')
      AssetType.stub(:find_by_id).
        with(3).
        and_return('at')
      Batch.stub(:find_by_id).
        with(3).
        and_return('bat')

    }

  context "new" do

    let(:request) { BatchesController.new().get_new }

    it "should return the New Batch presenter" do
      request.should be_an_instance_of(Presenter::BatchPresenter::New)
    end
  end

  context "show" do
    let(:request) { BatchesController.new(params).get}

    context "with a batch specified" do
      let(:params) {{:batch_id=>1}}

      it "should look up the appropriate batch" do
        Batch.should_receive(:find_by_id).with(1) { 'batch' }
        request
      end

      it "should pass the batch to the presenter" do
        Batch.stub(:find_by_id) { 'batch' }
        Presenter::BatchPresenter::Show.should_receive(:new).with('batch')
        request
      end

      it "should return the show batch presenter" do
        Batch.stub(:find_by_id) { 'batch' }
        request.should be_an_instance_of(Presenter::BatchPresenter::Show)
      end
    end

    context "without a batch specified" do
      let(:params) {{}}
      it "should require an id parameter" do
        expect { request }.to raise_error(Controller::ParameterError,'You must specify a batch.')
      end
    end
  end

  context "create" do

    let(:request) { BatchesController.new(params).post }

    context "with full parameters" do

      let(:params)  { {:workflow_id=>3,:asset_type_id=>3,:study=>'test',:assets=>{
        1=>{identifier:'a',sample_count:1},
        2=>{identifier:'b',sample_count:1}
      }, :comment => 'comment' } }


      it "should pass the options to a batch creator" do

        mocked_lookups

        Batch::Creator.should_receive(:create!).
          with(
            study:'test',
            workflow:'wf',
            asset_type:'at',
            assets:[
              {identifier:'a',sample_count:1},
              {identifier:'b',sample_count:1}
            ],
            comment: 'comment'
          )

        request
      end

      it "should return the show batch presenter for the new batch" do

        mocked_lookups

        Batch::Creator.stub(:create!).and_return('bat')
        Presenter::BatchPresenter::Show.should_receive(:new).with('bat').and_return('Pres')
        request.should eq('Pres')
      end

    end

    context "with missing asset type" do
      let(:params)  { {:workflow_id=>3,:study=>'test',:assets=>{1=>{}} } }
      it "should require an asset type" do
        expect { request }.to raise_error(Controller::ParameterError,'You must specify an asset type.')
      end
    end

    context "with missing workflow" do
      let(:params)  { {:asset_type=>3,:study=>'test',:assets=>{1=>{}} }  }
      it "should require a workflow" do
        expect { request }.to raise_error(Controller::ParameterError,'You must specify a workflow.')
      end
    end
    context "with no assets" do
      let(:params)  { {:workflow_id=>3,:asset_type_id=>3,:study=>'test' } }
      it "should require a hash of assets" do
        expect { request }.to raise_error(Controller::ParameterError,'You must register at least one asset.')
      end
    end
    context "with no study" do
      let(:params)  { {:asset_type_id=>3,:workflow_id=>3,:assets=>{1=>{}} }  }
      it "should require a study" do
        expect { request }.to raise_error(Controller::ParameterError,'You must specify a study.')
      end
    end
  end

  context "update" do

    let(:request) { BatchesController.new(params).put }

    context "with full parameters" do

      let(:params)  { {:batch_id=>3,:workflow_id=>3,:study=>'test',comment:'comment' } }

      it "should pass the options to a batch updater" do
        mocked_lookups
        Batch::Updater.should_receive(:create!).with(
          batch:'bat',
          workflow:'wf',
          study: 'test',
          comment:'comment'
        )
        request
      end

      it "should return the show batch presenter for the updated batch" do
        mocked_lookups
        Batch::Updater.stub(:create!).and_return('bat')
        Presenter::BatchPresenter::Show.should_receive(:new).with('bat').and_return('Pres')
        request.should eq('Pres')
      end
    end

    context "with missing workflow" do
      let(:params)  { {:batch_id=>1} }
      it "should require a workflow" do
        expect { request }.to raise_error(Controller::ParameterError,'You must specify a workflow.')
      end
    end
    context "with missing batch id" do
      let(:params)  { {:workflow_id=>1} }
      it "should require a batch_id" do
        expect { request }.to raise_error(Controller::ParameterError,'You must specify a batch.')
      end
    end
  end
  
  context "remove" do

    let(:request) { BatchesController.new(params).delete }

    context "with full parameters" do
      let(:params)  { {:batch_id=>3 } }
      it "should pass the options to a batch destroy" do
        mocked_lookups
        Batch.stub(:destroy!).and_return('bat')        
      end
    end

    context "with missing batch id" do
      let(:params)  { {}}
      it "should require a batch_id" do
        expect { request }.to raise_error(Controller::ParameterError,'You must specify a batch.')
      end
    end
  end

  context "index" do
    it "should raise an exception" do
      expect { BatchesController.new({}).get_index}.to raise_error(Controller::NotImplimented)
    end
  end

end
