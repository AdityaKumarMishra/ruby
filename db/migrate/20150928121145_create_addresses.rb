class CreateAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :addresses do |t|
      t.integer :number
      t.string :street_name
      t.string :street_type
      t.string :subburb
      t.string :city
      t.string :post_code
      t.string :state
      t.string :country
      t.integer :addresable_id
      t.string :addresable_type

      t.timestamps null: false
    end
  end
end
