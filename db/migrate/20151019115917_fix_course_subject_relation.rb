class FixCourseSubjectRelation < ActiveRecord::Migration[6.1]
  def up
    add_reference :subjects, :course, index: true, foreign_key: true
  end

  def down
    remove_reference :subjects, :course
  end
end
