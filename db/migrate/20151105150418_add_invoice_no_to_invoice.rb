class AddInvoiceNoToInvoice < ActiveRecord::Migration[6.1]
  def change
    add_column :invoices, :invoice_no, :string
  end
end
