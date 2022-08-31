FactoryGirl.define do
  factory :mcq do
    question 'Test question with $$LATEX$$ and <b>html</b>'
    difficulty 1.5
    explanation 'The test question explanation'
    examinable false
    publish true
    association :mcq_stem, factory: :mcq_stem, examinable: true
    tag

    trait :non_examinable do
      association :mcq_stem, factory: :mcq_stem, examinable: false
    end

    factory :mcq_with_answers do
      after(:build) do |m|
        m.mcq_answers << FactoryGirl.build(:mcq_answer, correct: true, mcq: m)
      end

      after(:create) do |m|
        m.mcq_answers << FactoryGirl.create(:mcq_answer, correct: true, mcq: m)
      end
    end
  end
end
