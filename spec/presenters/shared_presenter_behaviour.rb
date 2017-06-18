shared_examples "shared presenter behaviour" do
  it "should yield each asset_type and its identifier in turn for each_asset_type" do
    asset_type_1 = double("asset_type_1", :name=>'type1',:identifier_type=>'id1',:has_sample_count=>true,:id=>1)
    asset_type_2 = double("asset_type_2", :name=>'type2',:identifier_type=>'id2',:has_sample_count=>false,:id=>2)
    AssetType.stub(:all) {[asset_type_1,asset_type_2]}

    expect { |b| presenter.each_asset_type(&b) }.to yield_successive_args(['type1', 'id1', true,1], ['type2', 'id2', false,2])

  end

  it "should yield each workflow and its comment_requirement in turn for each_workflow" do
    workflow_1 = double("workflow_1", :name=>'wf1', :has_comment=>true, :id=>1, :reportable => true, humanized_team_name: 'Team name', :turn_around_days=>1 )
    workflow_2 = double("workflow_2", :name=>'wf2', :has_comment=>false, :id=>2, :reportable => false, humanized_team_name: 'Team name', :turn_around_days=>nil)
    relation = double("relation")
    Workflow.stub(:all) {relation}
    allow(relation).to receive(:includes).and_return([workflow_1,workflow_2])

    expect { |b| presenter.each_workflow(&b) }.to yield_successive_args(['wf1', true,1, true, 'Team name', 1], ['wf2', false,2, false, 'Team name', nil])
  end
end
