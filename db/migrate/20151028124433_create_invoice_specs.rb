class CreateInvoiceSpecs < ActiveRecord::Migration[6.1]
  def change
    create_table :invoice_specs do |t|
      t.references :invoice, index: true, foreign_key: true
      t.references :product, index: true, foreign_key: true
      t.string :name
      t.decimal :cost, precision: 7, scale: 2
      t.string :type
      t.float :weight
      t.float :lenght
      t.float :width
      t.float :height
      t.integer :ammount

      t.timestamps null: false
    end
  end
end