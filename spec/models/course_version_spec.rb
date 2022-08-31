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

require 'rails_helper'

RSpec.describe CourseVersion, type: :model do
  it {should validate_presence_of(:version_number)}
  it {should validate_presence_of(:date_added)}
  it {should validate_presence_of(:class_size)}
  it {should validate_presence_of(:expiry_date)}
  it {should validate_presence_of(:enrolment_end_added)}
  it {should validate_presence_of(:students_count)}
end
