class AddCourseIdToTextbook < ActiveRecord::Migration[6.1]
  def change
    add_reference :textbooks, :course, index: true, foreign_key: true
  end
end
