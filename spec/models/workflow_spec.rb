require 'spec_helper'
require './app/models/workflow'
require './app/models/flow'
require './app/models/flow_step'
require './app/models/step'

describe Workflow do

  context "with valid parameters" do
    let!(:test_name) { 'test' }
    let!(:has_comment) { true }
    let!(:flow) { create(:flow_with_steps, name: 'Flow') }
    let(:workflow) { Workflow.new(name: test_name, has_comment: has_comment, flow: flow) }

    it 'can be created' do
      workflow = Workflow.new(:name=>test_name,:has_comment=>has_comment,:turn_around_days=>2)
      workflow.valid?.should eq(true)
      expect(workflow).to have(0).errors_on(:name)
      expect(workflow).to have(0).errors_on(:has_comment)
      expect(workflow).to have(0).errors_on(:turn_around_days)
      workflow.name.should eq(test_name)
      workflow.has_comment?.should eq(has_comment)
    end

    it 'can be created with flow name' do
      workflow = Workflow.new(name: test_name, has_comment: has_comment, flow: 'Flow')
      expect(workflow.valid?).to be true
      expect(workflow.flow).to eq flow
    end

    it 'has many assets' do
      workflow.assets.new(:identifier=>'test')
      workflow.assets.size.should eq(1)
      workflow.assets.first.identifier.should eq('test')
    end

    it 'has a flow' do
      expect(workflow.flow).to eq flow
    end

    it 'should delegate initial_state_name to flow' do
      expect(workflow.initial_step_name).to eq flow.initial_step_name
    end

    # it 'should know its next step' do

    # end

  end

  context "with invalid parameters" do

    it 'requires a name' do
      workflow = Workflow.new()
      expect(workflow).to have(1).errors_on(:name)
      workflow.valid?.should eq(false)
    end

    it 'requires a unique name' do
      workflow = Workflow.create!(:name=>'test1')
      workflow = Workflow.create(:name=>'test1')
      expect(workflow).to have(1).errors_on(:name)
      workflow.valid?.should eq(false)
    end

    it 'can not have a negative turn around time' do
      workflow = Workflow.new(:name=>'test',:turn_around_days=>-1)
      expect(workflow).to have(1).errors_on(:turn_around_days)
      workflow.valid?.should eq(false)
    end

  end

end

