require 'spec_helper'
require './app/models/batch'

describe Batch do

  it 'has many assets' do
    batch = Batch.new
    batch.assets.new(:identifier=>'test')
    batch.assets.size.should eq(1)
    batch.assets.first.identifier.should eq('test')
  end

end
