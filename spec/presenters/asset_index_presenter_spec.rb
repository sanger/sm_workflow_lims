require 'spec_helper'
require './app/presenters/asset/index'

describe Presenter::AssetPresenter::Index do

  shared_examples "standard behaviour" do

    it "should return a count of assets for total"
    it "should yield each asset of type x in turn for each_asset(x)"
    it "should yield each asset_type and its identifier in turn for each_asset_type"
    it "should yield each workflow and its comment_requirement in turn for each_workflow"
  end

  context "when returning search results" do

    include_examples "standard behaviour"

    it "should yield the search parameters on search_parameters"
    # Eg. presenter.search_parameters {|sp| puts sp }
    # -> identifier matches 'my plate'
    it "should return true for is_search?"

  end

  context "when returning a complete index" do

    include_examples "standard behaviour"

    it "should not yield on search_parameters"
    # Eg. presenter.search_parameters {|sp| puts "Never called" }
    it "should return false for is_search?"

  end

end
