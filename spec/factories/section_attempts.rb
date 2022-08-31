FactoryGirl.define do
  factory :section_attempt do
    percentile nil
    mark 1
    completed_at '2016-03-01 02:22:28'
    association :section, factory: :section
    association :assessment_attempt, factory: :assessment_attempt
  end
end
