class CreateProductPackages < ActiveRecord::Migration[6.1]
  def change
    create_table :product_packages do |t|
      t.string :name
      t.datetime :valid_date
      t.decimal :cost, :precision=>7, :scale=>2
      t.float :weight, default: 0

      t.timestamps null: false
    end
  end
end
