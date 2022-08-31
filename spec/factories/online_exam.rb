FactoryGirl.define do
  factory :online_exam do
    title 'MyString'
    instruction 'MyText'
    position 1
    published false
    trait :published_with_sections do
      after(:create) do |exam|
        exam.sections = build_list(:section, 2, sectionable: exam)
        exam.published = true
        exam.save
      end
    end
    trait :published_without_sections do
      published true
    end
  end
end
