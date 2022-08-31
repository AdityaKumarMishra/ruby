class AddFinishDateToAppointments < ActiveRecord::Migration[6.1]
  def change
    add_column :appointments, :finish_date, :date
  end
end
