FactoryGirl.define do

  sequence :team_name do |n|
    "team_#{n}"
  end

  factory :team do
    name { generate :team_name }
    initialize_with { Team.find_or_create_by(name: name) }

    factory :sample_management_team do
      name 'sample_management'

      after(:create) do |team|
        ['in_progress', 'completed', 'report_required', 'reported'].each do |state_name|
          State.find_or_create_by(name: state_name)
        end
        team.procedures.where(state: State.find_by(name: 'in_progress'), final_state: State.find_by(name: 'completed'), order: 1).first_or_create
        team.procedures.where(state: State.find_by(name: 'report_required'), final_state: State.find_by(name: 'reported'), order: 2).first_or_create
      end
    end

    factory :dna_team do
      name 'dna'

      after(:create) do |team|
        ['volume_check', 'quant', 'completed', 'report_required', 'reported'].each do |state_name|
          State.find_or_create_by(name: state_name)
        end
        team.procedures.where(state: State.find_by(name: 'volume_check'), order: 1).first_or_create
        team.procedures.where(state: State.find_by(name: 'quant'), final_state: State.find_by(name: 'completed'), order: 2).first_or_create
        team.procedures.where(state: State.find_by(name: 'report_required'), final_state: State.find_by(name: 'reported'), order: 3).first_or_create
      end
    end

  end
end