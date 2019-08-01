FactoryGirl.define do

  sequence :asset_type_name do |n|
    "Asset type #{n}"
  end

  sequence :asset_type_identifier do |n|
    "Identifier #{n}"
  end

  factory :asset_type do
    name { generate :asset_type_name }
    identifier_type { generate :asset_type_identifier }
    labware_type { 'Plate' }

    factory :asset_type_has_sample_count do
      has_sample_count true
    end
  end

end
