class AddHoursToAppointment < ActiveRecord::Migration[6.1]
  def up
    add_column :appointments, :hours, :integer
    add_column :appointments, :content, :text
    Appointment.all.each do |appointment|
      next if appointment.start_time.nil? && appointment.end_time.nil? && appointment.hours.present?
      tutor_av = TutorAvailability.find_by(id: appointment.tutor_availability_id)
      tutor_id = tutor_av.tutor.id if tutor_av.present?
      appointment.update_columns(hours: 1, tutor_id: tutor_id)
    end
  end

  def down
    remove_column :appointments, :hours, :integer
    remove_column :appointments, :content, :text
  end
end
