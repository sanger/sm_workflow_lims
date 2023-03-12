FactoryBot.define do
  sequence :cost_code_name do |n|
    "A#{n}"
  end

  factory :cost_code do
    name { generate(:cost_code_name) }
  end
end
