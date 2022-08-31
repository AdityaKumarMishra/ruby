# == Schema Information
#
# Table name: course_versions
#
#  id                  :integer          not null, primary key
#  version_number      :integer
#  date_added          :datetime
#  class_size          :integer
#  expiry_date         :date
#  enrolment_end_added :datetime
#  students_count      :integer
#  course_id           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  start_date          :datetime
#  end_date            :datetime
#  is_user_version     :boolean
#  course_address_id   :integer
#

FactoryGirl.define do
  factory :course_version do
    version_number 1
    date_added "2015-09-28 14:31:26"
    class_size 10
    expiry_date "2015-09-28"
    enrolment_end_added "2015-09-28 14:31:26"
    students_count 1

    after(:build) { |course_version| course_version.class.skip_callback(:create, :after, :create_default_class) }

  end


end
