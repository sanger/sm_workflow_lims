FactoryGirl.define do

  sequence :workflow_name do |n|
    "Workflow #{n}"
  end

  factory :workflow do
    name { generate :workflow_name }

    trait :has_comment do
      has_comment true
    end

    trait :reportable do
      reportable true
    end

    trait :multi_team_quant_essential do
      multi_team_quant_essential true
    end

    factory :workflow_with_comment, traits: [:has_comment]
    factory :workflow_with_report, traits: [:reportable]
    factory :workflow_multi_team, traits: [:multi_team_quant_essential]
    factory :workflow_multi_team_reportable, traits: [:multi_team_quant_essential, :reportable]

  end

end