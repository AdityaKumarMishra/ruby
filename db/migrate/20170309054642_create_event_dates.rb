class CreateEventDates < ActiveRecord::Migration[6.1]
  def change
    create_table :event_dates do |t|
      t.timestamps null: false
      t.string :title
      t.date :event_start_date
      t.datetime :event_start_time
      t.datetime :event_end_time
      t.text :description
      t.integer :product_version_id
      t.string :product_line
    end
  end
end
