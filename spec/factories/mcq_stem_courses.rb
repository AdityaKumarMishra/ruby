# == Schema Information
#
# Table name: mcq_stem_courses
#
#  id          :integer          not null, primary key
#  mcq_stem_id :integer
#  course_id   :integer
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#

FactoryGirl.define do
  factory :mcq_stem_course do
    mcq_stem nil
course nil
  end

end
