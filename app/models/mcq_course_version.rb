class McqCourseVersion < ApplicationRecord
  belongs_to :mcq_stem
  belongs_to :course_version
end
