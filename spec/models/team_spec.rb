require 'rails_helper'

describe Team do

  let(:team) { Team.new }
  let(:sample_management_team) { create :sample_management_team}
  let(:dna_team) { create :dna_team }

  it 'should have name' do
    expect(team.valid?).to be false
    team.name = 'name'
    expect(team.valid?).to be true
  end

  it 'should know procedure that uses particular state' do
    quant = create :state, name: 'quant'
    expect(sample_management_team.procedure_for(quant)).to be nil
    expect(dna_team.procedure_for(quant).order).to eq 2
  end

  it 'should know next procedure' do
    procedure1 = Procedure.create(order: 1, state: (create :state))
    procedure2 = Procedure.create(order: 2, state: (create :state))
    team = create :team
    team.procedures << procedure2
    team.procedures << procedure1
    expect(team.procedure_after(procedure1)).to eq procedure2
    expect(team.procedure_after(procedure2)).to be nil
  end

end