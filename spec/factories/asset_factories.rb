FactoryBot.define do
  sequence :asset_identifier do |n|
    "Asset #{n}"
  end

  sequence :asset_study do |n|
    "Study#{n}"
  end

  factory :asset do
    identifier { generate(:asset_identifier) }
    study { generate(:asset_study) }
    workflow
    batch
    asset_type
  end
end
