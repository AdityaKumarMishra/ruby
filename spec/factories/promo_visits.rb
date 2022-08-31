FactoryGirl.define do
  factory :promo_visit do
    promo
  end

  trait :previous_week do
    created_at { 1.week.ago + 1.day }
  end

  trait :current_week do
    created_at { Time.zone.now.beginning_of_week + 1.day }
  end
end
