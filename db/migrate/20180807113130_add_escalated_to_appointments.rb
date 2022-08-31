class AddEscalatedToAppointments < ActiveRecord::Migration[6.1]
  def up
    add_column :appointments, :escalated, :boolean, default: false
  end

  def down
    remove_column :appointments, :escalated
  end
end
