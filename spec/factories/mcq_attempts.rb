FactoryGirl.define do
  factory :mcq_attempt do
    association :exercise, factory: :exercise
    association :mcq_stem, factory: :mcq_stem
    association :mcq, factory: :mcq
    association :mcq_answer, factory: :mcq_answer
    user_id { exercise.user.id }

    after(:create) do |m|
      m.mcq_stem = m.mcq.mcq_stem
      m.mcq_answer = m.mcq.mcq_answers.first
    end
  end
end
