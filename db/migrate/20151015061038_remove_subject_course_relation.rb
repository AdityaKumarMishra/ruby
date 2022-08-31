class RemoveSubjectCourseRelation < ActiveRecord::Migration[6.1]
  def up
    remove_reference :subjects, :course
  end

  def down
    add_reference :subjects, :course, index: true, foreign_key: true
  end
end
