class CreateContactLocations < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_locations do |t|
      t.string :name

      t.timestamps null: false
    end
  end
end
