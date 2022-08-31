class CreateTutorSchedules < ActiveRecord::Migration[6.1]
  def change
    create_table :tutor_schedules do |t|
      t.integer :repeatability
      t.datetime :start_time
      t.datetime :end_time
      t.text :location
      t.references :tutor_profile

      t.timestamps null: false
    end
  end
end