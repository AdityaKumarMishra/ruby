FactoryGirl.define do
  factory :promo do
    name 'Test promo'
    token nil
    stackable false
    user
    strategy :percentage
    amount "0.5"
    used_times 5
  end

  trait :tokened do
    token { FFaker::Internet.slug }
  end

  trait :stackable do
    stackable true
  end
end
