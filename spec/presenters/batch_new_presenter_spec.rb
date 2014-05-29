require 'spec_helper'
require './app/presenters/batch/new'

describe Presenter::BatchPresenter::New do

  let(:batch_new_presenter) { Presenter::BatchPresenter::New.new }

  context "always" do

    # asset_type_1 = double("asset_type_1", :name=>'type1',:identifier_type=>'id1',:variable_samples=>true)
    # asset_type_2 = double("asset_type_2", :name=>'type2',:identifier_type=>'id2',:variable_samples=>false)
    # AssetType.stub(:all) {[asset_type_1,asset_type_2]}

    # workflow_1 = double("workflow_1", :name=>'type1', :has_comment=>true )
    # workflow_2 = double("workflow_2", :name=>'type2', :has_comment=>false)
    # Workflow.stub(:all) {[workflow_1,workflow_2]}



    it "should yield each asset_type and its identifier in turn for each_asset_type" do
    end

    it "should yield each workflow and its comment_requirement in turn for each_workflow" do
    end

  end
end
