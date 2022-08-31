class AddExpiryDatetoPromo < ActiveRecord::Migration[6.1]
  def change
    add_column :promos, :expiry_date, :date
  end
end
