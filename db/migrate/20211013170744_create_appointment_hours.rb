class CreateAppointmentHours < ActiveRecord::Migration[6.1]
  def change
    create_table :appointment_hours do |t|
    	t.belongs_to :appointment
    	t.integer :hours
    	t.integer :left_hours
    	t.datetime :finish_date
      t.timestamps null: false
    end
  end
end
