FactoryGirl.define do
  factory :assessment_attempt do
    association :user, factory: :user

    association :assessable, factory: [:online_exam, :published_with_sections]

    trait :diagnostic_test_type do
      association :assessable, factory: :diagnostic_test, published: true
    end

    trait :online_exam_type do
      association :assessable, factory: [:online_exam, :published_with_sections]
    end

    percentile 1.5
    mark 2
    completed_at '2016-03-02 04:28:47'
  end
end
