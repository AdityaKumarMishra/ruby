class AddAllowBookingUntilToTutorSchedules < ActiveRecord::Migration[6.1]
  def change
    add_column :tutor_schedules, :allow_booking_until, :integer, default: 7
  end
end
