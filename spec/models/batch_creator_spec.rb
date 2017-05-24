require 'rails_helper'

describe Batch::Creator do

  before do
    Timecop.freeze(Time.local(2017, 3, 7))
  end

  it 'should not be valid if the begun_at date is wrong, required attributes were not provided' do
    batch_creator = Batch::Creator.new(
      begun_at: '05/05/2017',
      project: 'project',
      pipeline_destination: (create :pipeline_destination),
      cost_code: (create :cost_code),
      comment: 'some comment'
    )
    expect(batch_creator.valid?).to be false
    expect(batch_creator.errors.messages.count).to eq 5
    expect(batch_creator).to have(1).errors_on(:study)
    expect(batch_creator).to have(1).errors_on(:assets)
    expect(batch_creator).to have(1).errors_on(:asset_type)
    expect(batch_creator).to have(1).errors_on(:workflow)
    expect(batch_creator).to have(1).errors_on(:dates)
  end

  it 'should create the right batch and the right assets' do
    state = create :state, name: 'in_progress'
    assets = [{type: "Plate", identifier: "test", sample_count: "25"},
             {type: "Plate", identifier: "test2", sample_count: "10"},
             {type: "Plate", identifier: "test3", sample_count: "96"}]
    workflow = create :workflow

    batch_creator = Batch::Creator.new(
      study: 'study',
      project: 'project',
      assets: assets,
      asset_type: (create :asset_type_has_sample_count),
      workflow: workflow,
      pipeline_destination: (create :pipeline_destination),
      cost_code: (create :cost_code),
      comment: 'some comment'
    )
    expect(Asset.count).to eq 0
    batch_creator.create!
    expect(Asset.count).to eq 3
    expect(Asset.last.current_state). to eq state.name
  end

  after do
    Timecop.return
  end

end