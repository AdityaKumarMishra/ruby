class CourseStaff < ApplicationRecord
  belongs_to :staff_profile
  belongs_to :course
end
