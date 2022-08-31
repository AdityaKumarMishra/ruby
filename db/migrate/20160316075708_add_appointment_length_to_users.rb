class AddAppointmentLengthToUsers < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :appointment_length, :integer, default: 60
  end
end
