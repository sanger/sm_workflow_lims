FactoryGirl.define do
  sequence :pipeline_destination_name do |n|
    "Pipeline destination #{n}"
  end

  factory :pipeline_destination do
    name { generate :pipeline_destination_name }
  end
end
