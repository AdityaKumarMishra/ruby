FactoryGirl.define do
  factory :order do
    reference_number {FFaker::IdentificationMX.rfc }
    redundant_total_cost "9.99"
    redundant_method_fee "9.99"
    status :pending
    brain_tree_reference {FFaker::IdentificationMX.rfc }
    paid_at "2016-05-05 21:51:03"
    user { FactoryGirl.create(:user, :student) }
  end

  trait :ongoing do
    status :ongoing
  end

  trait :with_minimum_spend do
    after(:create) { |order|
      order.purchase_items << FactoryGirl.create(:purchase_item, :expensive)
    }
  end
end
