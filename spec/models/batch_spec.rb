require 'rails_helper'

describe Batch do

  it 'has many assets' do
    batch = Batch.new
    batch.assets.new(:identifier=>'test')
    expect(batch.assets.size).to eq(1)
    expect(batch.assets.first.identifier).to eq('test')
  end

  it 'destroy assets when destroyed' do
    batch = Batch.new
    batch.assets.new(:identifier=>'test')
    batch.assets.new(:identifier=>'test2')
    assets = batch.assets
    batch.destroy!
    expect(assets.map(&:destroyed?).all?).to be_truthy
  end

end
