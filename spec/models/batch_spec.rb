require 'spec_helper'
require './app/models/batch'

describe Batch do

  it 'has many assets' do
    batch = Batch.new
    batch.assets.new(:identifier=>'test')
    batch.assets.size.should eq(1)
    batch.assets.first.identifier.should eq('test')
  end

  it 'destroy assets when destroyed' do
    batch = Batch.new
    batch.assets.new(:identifier=>'test')
    batch.assets.new(:identifier=>'test2')
    assets = batch.assets

    batch.destroy!
    assets.map(&:destroyed?).all?.should eq(true)
  end

end

describe Batch::Creator do

  it 'should create the right batch and the right assets' do
    state = create :state, name: 'in_progress'
    assets = [{type: "Plate", identifier: "test", sample_count: "25"},
             {type: "Plate", identifier: "test2", sample_count: "10"},
             {type: "Plate", identifier: "test3", sample_count: "96"}]
    workflow = create :workflow

    batch_creator = Batch::Creator.new(
      study: 'study',
      assets: assets,
      asset_type: (create :asset_type_has_sample_count),
      workflow: workflow,
      pipeline_destination: (create :pipeline_destination),
      cost_code: (create :cost_code),
      comment: 'some comment'
    )
    expect(Asset.count).to eq 0
    batch_creator.do!
    expect(Asset.count).to eq 3
    expect(Asset.last.current_state). to eq state.name
  end

end
