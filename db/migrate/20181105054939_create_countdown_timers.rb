class CreateCountdownTimers < ActiveRecord::Migration[6.1]
  def change
    create_table :countdown_timers do |t|
      t.string :title
      t.string :description
      t.date :end_date
      t.time :end_time
      t.integer :page_type
      t.string :destination_link
      t.boolean :active, default: false

      t.timestamps null: false
    end
  end
end
