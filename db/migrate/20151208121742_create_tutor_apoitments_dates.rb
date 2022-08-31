class CreateTutorApoitmentsDates < ActiveRecord::Migration[6.1]
  def change
    create_table :tutor_apoitments_dates do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :start_time
      t.datetime :end_time
      t.integer :repeatability
      t.text :location

      t.timestamps null: false
    end
  end
end