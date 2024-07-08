require 'rails_helper'
# require './app/presenters/batch_presenter/new'
# require './spec/presenters/shared_presenter_behaviour'

describe 'Presenter::BatchPresenter::New' do
  let(:presenter) { Presenters::BatchPresenter::New.new }

  context 'always' do
    include_examples('shared presenter behaviour')
  end
end
