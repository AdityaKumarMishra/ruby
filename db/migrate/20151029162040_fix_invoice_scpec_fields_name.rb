class FixInvoiceScpecFieldsName < ActiveRecord::Migration[6.1]
  def change
    rename_column :invoice_specs, :ammount, :amount
    rename_column :invoice_specs, :lenght, :length
  end
end
