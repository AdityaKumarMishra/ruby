class CreateUserAddresses < ActiveRecord::Migration[6.1]
  def change
    create_table :user_addresses do |t|
      t.integer :number
      t.string :street_name
      t.string :street_type
      t.string :subburb
      t.string :city
      t.string :post_code
      t.string :state
      t.string :country
      t.references :user, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
