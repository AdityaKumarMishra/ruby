FactoryGirl.define do
  factory :purchase_addon do
    paid_at "2016-03-12 17:00:38"
date_activated "2016-03-12 17:00:38"
date_deactivated "2016-03-12 17:00:38"
features "MyText"
subtotal 1.5
gst 1.5
paypal_fee 1.5
paypal_payment "MyString"
paypal_token "MyString"
banktrans "MyString"
paypal false
bank false
  end

end
