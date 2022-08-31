class AddQuantityAndProductTypeToInvoiceSpec < ActiveRecord::Migration[6.1]
  def change
    add_reference :invoice_specs, :product_type, index: true, foreign_key: true
    add_column :invoice_specs, :quantity, :integer
  end
end
