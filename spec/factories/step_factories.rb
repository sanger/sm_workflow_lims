FactoryGirl.define do

  sequence :step_name do |n|
    "Step #{n}"
  end

  factory :step do
    name { generate :step_name }
  end

end