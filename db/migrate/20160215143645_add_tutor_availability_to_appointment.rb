class AddTutorAvailabilityToAppointment < ActiveRecord::Migration[6.1]
  def change
    add_reference :appointments, :tutor_availability, index: true, foreign_key: true
  end
end
