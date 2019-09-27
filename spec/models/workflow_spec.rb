require 'rails_helper'

describe Workflow do

  let!(:volume_check) { create :state, name: 'volume_check' }

  context "with valid parameters" do
    let!(:test_name) { 'test' }
    let!(:has_comment) { true }
    let(:workflow) { Workflow.new(name: test_name, has_comment: has_comment, initial_state_name: 'volume_check') }

    it 'can be created' do
      workflow = Workflow.new(:name=>test_name,:has_comment=>has_comment,:turn_around_days=>2, initial_state: volume_check)
      expect(workflow).to be_valid
      expect(workflow).to have(0).errors_on(:name)
      expect(workflow).to have(0).errors_on(:has_comment)
      expect(workflow).to have(0).errors_on(:turn_around_days)
      expect(workflow.name).to eq(test_name)
      expect(workflow.has_comment?).to eq(has_comment)
    end

    it 'has many assets' do
      workflow.assets.new(:identifier=>'test')
      expect(workflow.assets.size).to eq(1)
      expect(workflow.assets.first.identifier).to eq('test')
    end

    it 'should know its initial state' do
      expect(workflow.initial_state).to eq volume_check
    end

  end

  context "with invalid parameters" do

    it 'requires a name' do
      workflow = Workflow.new()
      expect(workflow).to have(1).errors_on(:name)
      expect(workflow).to_not be_valid
    end

    it 'requires a unique name' do
      workflow = Workflow.create!(:name=>'test1', initial_state: volume_check)
      workflow = Workflow.create(:name=>'test1')
      expect(workflow).to have(1).errors_on(:name)
      expect(workflow).to_not be_valid
    end

    it 'can not have a negative turn around time' do
      workflow = Workflow.new(:name=>'test',:turn_around_days => -1)
      expect(workflow).to have(1).errors_on(:turn_around_days)
      expect(workflow).to_not be_valid
    end
  end
end

