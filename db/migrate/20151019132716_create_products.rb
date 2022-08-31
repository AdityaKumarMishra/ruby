class CreateProducts < ActiveRecord::Migration[6.1]
  def change
    create_table :products do |t|
      t.string :sku
      t.string :currency
      t.string :name
      t.text :description
      t.decimal :cost, :precision=>7, :scale=>2
      t.string :type
      t.float :weight
      t.float :length
      t.float :width
      t.float :height
      t.datetime :starting_date
      t.datetime :stopping_date
      t.datetime :expiration_date
      t.references :course_version, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
