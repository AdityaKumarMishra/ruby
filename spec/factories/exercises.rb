FactoryGirl.define do
  factory :exercise do
    name { FFaker::Name.name }
    difficulty :easy
    amount 1
    completed_at nil
    association :user, factory: :user

    after(:build) do |e|
      tag = FactoryGirl.create(:tag)
      e.tags << tag
      mcq_stem = FactoryGirl.create :mcq_stem, difficulty: 20, tag_ids: [tag.id]
      FactoryGirl.create :mcq_attempt, mcq_stem: mcq_stem, exercise: e
    end

    trait :medium do
      difficulty :medium
    end

    trait :hard do
      difficulty :hard
    end
  end
end
