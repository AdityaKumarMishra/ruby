class AddFieldsToCourses < ActiveRecord::Migration[6.1]
  def change
    add_column     :courses, :visible_to_student, :boolean, default: false
    add_column     :courses, :notify_student,     :boolean, default: false
  end
end
