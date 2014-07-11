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
