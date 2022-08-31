FactoryGirl.define do
  factory :section do
    title 'MyString'
    duration 1
    position { rand(1000000)}
    association :sectionable, factory: :online_exam
  end
end
