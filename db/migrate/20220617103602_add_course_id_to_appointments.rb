class AddCourseIdToAppointments < ActiveRecord::Migration[6.1]
  def change
    add_reference :appointments, :course, foreign_key: true
  end
end
