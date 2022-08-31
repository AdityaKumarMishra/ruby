FactoryGirl.define do
  factory :feature_log do
    enrolment { FactoryGirl.create(:enrolment) }
    product_version_feature_price { FactoryGirl.create(:product_version_feature_price) }
  end
end
