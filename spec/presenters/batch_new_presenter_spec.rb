require 'spec_helper'
require './app/presenters/batch/new'

describe Presenter::BatchPresenter::New do

  context "always" do
    it "should yield each asset_type and its identifier in turn for each_asset_type"
    it "should yield each workflow and its comment_requirement in turn for each_workflow"
    it "should return the study_name (of the first asset) for study"
    it "should return the workflow (of the first asset) for workflow"
    it "should return the comment (of the first asset) for comment"
  end
end
