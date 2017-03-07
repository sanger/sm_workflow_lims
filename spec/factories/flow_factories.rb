FactoryGirl.define do

  sequence :flow_name do |n|
    "Flow #{n}"
  end

  factory :flow do
    name { generate :flow_name }

    factory :flow_with_steps do

      after(:create) do |flow|
        3.times {|n| flow.flow_steps << (create :flow_step, position: n+2)}
      end

    end

    factory :standard_flow do
      name 'standard'
      after(:create) do |flow|
        flow.flow_steps << create(:flow_step, step: (create :step, name: 'in_progress'), position: 0)
      end
    end

    factory :multi_team_flow do
      name 'multi_team_quant_essential'
      after(:create) do |flow|
        flow.flow_steps << create(:flow_step, step: (create :step, name: 'volume_check'), position: 0)
        flow.flow_steps << create(:flow_step, step: (create :step, name: 'quant'), position: 1)
      end

      factory :multi_team_reportable_flow do
        after(:create) do |flow|
          flow.flow_steps << create(:flow_step, step: (create :step, name: 'report_required'), position: 2)
        end
      end
    end

  end

end