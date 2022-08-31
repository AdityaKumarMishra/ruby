class CreateInvoices < ActiveRecord::Migration[6.1]
  def change
    create_table :invoices do |t|
      t.references :user, index: true, foreign_key: true
      t.datetime :invoice_date
      t.datetime :date_ordered
      t.datetime :date_billed
      t.datetime :date_shipment
      t.integer :payment_method
      t.decimal :total_amount, precision: 8, scale: 2
      t.decimal :gst_total_amount, precision: 8, scale: 2

      t.timestamps null: false
    end
    add_attachment :invoices, :invoice_file
  end
end