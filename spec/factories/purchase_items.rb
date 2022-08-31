FactoryGirl.define do
  factory :purchase_item do
    initial_cost "9.99"
    added_gst "9.99"
    method_fee "9.99"
    purchase_description "MyString"
    user
    purchasable factory: :enrolment
    association :order, factory: :order
  end

  trait :expensive do
    initial_cost "799.99"
  end
end
