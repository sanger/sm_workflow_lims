FactoryBot.define do
  sequence :state_name do |n|
    "State #{n}"
  end

  factory :state do
    name { generate(:state_name) }
    initialize_with { State.find_or_create_by(name:) }
  end
end
