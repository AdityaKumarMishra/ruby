FactoryGirl.define do
  factory :course do
    slug { FFaker::Internet.slug }
    name "MyString"
    class_size 2
    expiry_date Time.zone.today + 2.days
    enrolment_end_date Time.zone.today + 10.days
    product_version
    staff_profile_ids { [FactoryGirl.create(:staff_profile).id] }

    to_create {|instance| instance.save(validate: false) }

    after(:create) do |course|
      FactoryGirl.create_list(:transfer_transaction, 2, course: course)
      FactoryGirl.create(:lesson, course_id: course.id)
    end
  end

  trait :with_enrolment do
    after(:create) do |course|
      FactoryGirl.create_list(:enrolment, 1, course: course)
    end
  end
end
