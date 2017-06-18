require 'rails_helper'

describe Workflow do

  let!(:volume_check) { create :state, name: 'volume_check' }
  let!(:dna_team) { create :dna_team }

  context "with valid parameters" do
    let!(:test_name) { 'test' }
    let!(:has_comment) { true }
    let(:workflow) { Workflow.new(name: test_name, has_comment: has_comment, team_name: 'dna') }

    it 'can be created' do
      workflow = Workflow.new(:name=>test_name,:has_comment=>has_comment,:turn_around_days=>2, team: dna_team)
      workflow.valid?.should eq(true)
      expect(workflow).to have(0).errors_on(:name)
      expect(workflow).to have(0).errors_on(:has_comment)
      expect(workflow).to have(0).errors_on(:turn_around_days)
      workflow.name.should eq(test_name)
      workflow.has_comment?.should eq(has_comment)
    end

    it 'has many assets' do
      workflow.assets.new(:identifier=>'test')
      workflow.assets.size.should eq(1)
      workflow.assets.first.identifier.should eq('test')
    end

    it 'should know its first state' do
      expect(workflow.first_state).to eq volume_check
    end

  end

  context "with invalid parameters" do

    it 'requires a name and a team' do
      workflow = Workflow.new()
      expect(workflow).to have(1).errors_on(:name)
      # expect(workflow).to have(1).errors_on(:team)
      workflow.valid?.should eq(false)
    end

    it 'requires a unique name' do
      workflow = Workflow.create!(:name=>'test1', team: dna_team)
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

