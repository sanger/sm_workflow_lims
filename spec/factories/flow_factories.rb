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

  end

end