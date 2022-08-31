class AddDatesToInvoiceSpec < ActiveRecord::Migration[6.1]
  def change
    add_column :invoice_specs, :starting_date, :datetime
    add_column :invoice_specs, :stopping_date, :datetime
    add_column :invoice_specs, :expiration_date, :datetime
  end
end
