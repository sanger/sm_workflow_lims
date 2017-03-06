FactoryGirl.define do

  sequence :event_step do |n|
    "step #{n}"
  end

  factory :event do
    asset
    from { generate :event_step }
    to { generate :event_step }
  end

end