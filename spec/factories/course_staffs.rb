FactoryGirl.define do
  factory :course_staff do
    staff_profile { FactoryGirl.create :staff_profile }
    course { FactoryGirl.create :course }
  end
end
