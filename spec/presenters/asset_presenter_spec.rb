require 'spec_helper'
require './app/presenters/asset/asset'

describe Presenter::AssetPresenter::Asset do

  shared_examples "shared behaviour" do
    it "should return the identifier type for identifier_type"
    it "should return the identifier for identifier"
    it "should return the sample count for sample_count"
    it "should return the study_name for study"
    it "should return the workflow for workflow"
    it "should return the created at time as a formatted string for created_at"
  end

  context "with an asset with comments" do
    include_examples "shared behaviour"
    it "should return the comment for comments"
  end

  context "with an asset without comments" do
    include_examples "shared behaviour"
    it "should return an empty string for comments"
  end

  context "an unfinished asset" do
    include_examples "shared behaviour"
    it "should return 'in progress' for completed_at"
  end

  context "an unfinished asset" do
    include_examples "shared behaviour"
    it "should return 'in progress' for completed_at"
  end

end
