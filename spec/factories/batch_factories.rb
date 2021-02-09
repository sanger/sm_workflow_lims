FactoryGirl.define do
  factory :batch do
    factory :batch_with_assets do
      transient do
        assets_count { 3 }
      end

      after(:create) do |batch, evaluator|
        create_list(:asset, evaluator.assets_count, batch: batch)
      end
    end
  end
end
