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

class McqStemCourse < ApplicationRecord
  belongs_to :mcq_stem
  belongs_to :course
end
