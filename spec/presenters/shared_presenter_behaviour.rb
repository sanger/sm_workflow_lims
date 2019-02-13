shared_examples "shared presenter behaviour" do
  let!(:asset_type_1) { create :asset_type, name: 'type1', identifier_type: 'id1', has_sample_count: true }
  let!(:asset_type_2) { create :asset_type, name: 'type2', identifier_type: 'id2', has_sample_count: false }
  let!(:workflow_1) { create :multi_team_workflow, name: 'wf1', has_comment: true, reportable: true, turn_around_days: 1 }
  let!(:workflow_2) { create :non_multi_team_workflow, name: 'wf2', has_comment: false, reportable: false, turn_around_days: nil, active: false }

  it "should yield each asset_type and its identifier in turn for each_asset_type" do
    yielded = []
    presenter.each_asset_type do |name, identifier_type, has_sample_count, _id|
      yielded << [name, identifier_type, has_sample_count]
    end
    expect(yielded).to eq([['type1', 'id1', true], ['type2', 'id2', false]])

  end

  it "should yield each workflow and its comment_requirement in turn for each_workflow" do
    yielded = []
    presenter.each_workflow do |name, has_comment, _id, reportable, multi_team, turn_around_days, active|
      yielded << [name, has_comment, reportable, multi_team, turn_around_days, active]
    end
    expect(yielded).to eq([['wf1', true, true, true, 1, true], ['wf2', false, false, false, nil, false]])
  end

  it "should yield only active workflows" do
    yielded = []
    presenter.active_workflows do |name, has_comment, _id, reportable, multi_team, turn_around_days, active|
      yielded << [name, has_comment, reportable, multi_team, turn_around_days, active]
    end
    expect(yielded).to eq([['wf1', true, true, true, 1, true]])
  end

end
