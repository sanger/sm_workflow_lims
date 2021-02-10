FactoryBot.define do
  sequence :workflow_name do |n|
    "Workflow #{n}"
  end

  factory :workflow do
    name { generate :workflow_name }
    has_comment { false }
    reportable { false }
    turn_around_days { nil }
    active { true }
    qc_flow { false }
    cherrypick_flow { false }
    association :initial_state, factory: :state, name: 'in_progress'

    factory :qc_workflow do
      qc_flow { true }
      association :initial_state, factory: :state, name: 'volume_check'
    end

    factory :cherrypick_workflow do
      cherrypick_flow { true }
      association :initial_state, factory: :state, name: 'cherrypick'

      factory :cherrypick_qc_workflow do
        qc_flow { true }
      end
    end
  end
end
