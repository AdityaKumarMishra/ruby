class CreateShippings < ActiveRecord::Migration[6.1]
  def change
    create_table :shippings do |t|

      t.string  :country
      t.decimal :shipping_amount

      t.timestamps null: false
    end
  end
end
