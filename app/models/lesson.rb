class Lesson < ApplicationRecord
  # default_scope { order(:id) }

  enum lesson_type: ["Live Class" , "Mock Exam"]

end
