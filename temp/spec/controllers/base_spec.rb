require 'spec_helper'
require './app/controllers/controller'

describe Controller do

  class TestController < Controller

    required_parameters_for :create, [:required], 'The required field must be completed.'
    validate_parameters_for :create, :valid_parameters, 'Something else went wrong'

    def valid_parameters
      params[:required] == 'valid'
    end

    def create
      'created'
    end

    def show
      'show'
    end
  end

  context "A test controller" do

    it 'should raise NotImplimented on invalid endpoints' do
      expect { TestController.new({}).put}.to raise_error(Controller::NotImplimented)
    end

    it 'should not raise NotImplimented on valid endpoints' do
      TestController.new({}).show.should eq('show')
    end

    it 'should raise ParamterError when required fields are missing' do
      expect { TestController.new({}).post}.to raise_error(Controller::ParameterError,'The required field must be completed.')
    end

    it 'should raise ParamterError when required fields fail checks' do
      expect { TestController.new({:required=>'invalid'}).post}.to raise_error(Controller::ParameterError,'Something else went wrong')
    end

    it 'should be happy when parameters are present and correct' do
      TestController.new({:required=>'valid'}).post.should eq('created')
    end

  end

end
