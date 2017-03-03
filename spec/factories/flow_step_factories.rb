FactoryGirl.define do

  sequence :flow_step_position do |n|
    n
  end

  factory :flow_step do
    step
    flow
    position { generate :flow_step_position }
  end

end