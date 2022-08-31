class CreateAreas < ActiveRecord::Migration[6.1]
  def change
    create_table :areas do |t|
      t.string :city

      t.timestamps null: false
    end
    add_index :areas, :city
  end
end
