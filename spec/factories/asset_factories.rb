FactoryGirl.define do

  sequence :asset_identifier do |n|
    "Asset #{n}"
  end

  sequence :asset_study do |n|
    "Study #{n}"
  end

  sequence :asset_current_state do |n|
    "current state #{n}"
  end

  factory :asset do
    identifier { generate :asset_identifier }
    study { generate :asset_study }
    current_state { generate :asset_current_state }
    workflow
    batch
    asset_type
  end

end