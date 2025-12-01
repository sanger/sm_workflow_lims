require 'rails_helper'

describe 'BatchPresenter::New' do
  let(:presenter) { BatchPresenter::New.new }

  context 'always' do
    it_behaves_like('shared presenter behaviour')
  end
end
