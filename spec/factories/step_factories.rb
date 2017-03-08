FactoryGirl.define do

  sequence :step_name do |n|
    "Step #{n}"
  end

  factory :step do
    name { generate :step_name }
    initialize_with { Step.find_or_create_by(name: name) }
  end

end