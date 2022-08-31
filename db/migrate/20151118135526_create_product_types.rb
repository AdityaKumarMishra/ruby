class CreateProductTypes < ActiveRecord::Migration[6.1]
  def change
    create_table :product_types do |t|
      t.string :name
      t.string :type

      t.timestamps null: false
    end
  end
end