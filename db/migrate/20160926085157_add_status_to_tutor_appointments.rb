class AddStatusToTutorAppointments < ActiveRecord::Migration[6.1]
  def change
    add_column :appointments, :status, :integer, default: 0, null: false
  end
end
