namespace :appointments do
  task destroy_all_appointments: :environment do
    Appointment.destroy_all
  end
end
