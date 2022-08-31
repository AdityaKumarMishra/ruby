class RenameApoitmentToAppointment < ActiveRecord::Migration[6.1]
  def change
    rename_table :apoitments, :appointments
  end
end
