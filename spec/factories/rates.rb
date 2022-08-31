FactoryGirl.define do
  factory :rate do
    association :rater, factory: :user
    rateable nil
    description "My string"
  end
end
