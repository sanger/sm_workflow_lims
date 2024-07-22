require 'rails_helper'

describe 'BatchPresenter::New' do
  let(:presenter) { BatchPresenter::New.new }

  context 'always' do
    include_examples('shared presenter behaviour')
  end
end
