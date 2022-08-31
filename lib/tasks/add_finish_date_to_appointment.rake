namespace :add_finish_date_to_appointment do
  desc "Task description"
  task add_finish_date: :environment do
    Appointment.where(finish_date: nil).each do |appointment|
      date = appointment.start_time.present? ? appointment.start_time : appointment.created_at
      appointment.update_attribute(:finish_date, date)
    end
  end
end
