FactoryGirl.define do
  factory :product_version_feature_price do
    product_version { FactoryGirl.create(:product_version) }
    master_feature { FactoryGirl.create(:master_feature) }
    price 256.0

    after(:build) do |e|
      tag = FactoryGirl.create(:tag)
      e.tags << tag
    end

    trait :with_hardcopy do
      master_feature { FactoryGirl.create(:master_feature, :hardcopy) }
    end
  end
end
