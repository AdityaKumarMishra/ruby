FactoryGirl.define do
  factory :tag do
    # use password to keep name uniqueness for test environment

    name { FFaker::Lorem.word + FFaker::Lorem.characters(5) }
    description 'MyText'
    tagging_count 1
    parent_id nil
  end

  trait :with_staffs do
    staff_profiles { create_list :staff_profile, 1 }
  end
end
