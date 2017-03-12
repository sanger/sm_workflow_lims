FactoryGirl.define do

  sequence :workflow_name do |n|
    "Workflow #{n}"
  end

  factory :workflow do
    name { generate :workflow_name }

    factory :workflow_with_comment do
      has_comment true
    end

    factory :workflow_with_report do
      reportable true
    end
  end

end