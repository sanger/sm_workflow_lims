FactoryGirl.define do

  sequence :state_name do |n|
    "State #{n}"
  end

  factory :state do
    name { generate :state_name }
  end

end