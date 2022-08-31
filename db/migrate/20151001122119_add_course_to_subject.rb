class AddCourseToSubject < ActiveRecord::Migration[6.1]
  def change
    add_reference :subjects, :course, index: true, foreign_key: true
  end
end
