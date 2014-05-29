require 'spec_helper'
require './app/presenters/batch/show'

describe Presenter::BatchPresenter::Show do

  context "with a batch" do
    it "should yield each asset_type and its identifier in turn for each_asset_type"
    it "should yield each workflow and its comment_requirement in turn for each_workflow"
    it "should yield each asset in the batch in turn for each_asset"
  end
end

