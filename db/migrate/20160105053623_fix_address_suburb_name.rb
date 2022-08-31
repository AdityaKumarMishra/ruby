class FixAddressSuburbName < ActiveRecord::Migration[6.1]
  def change
    rename_column :addresses, :subburb, :suburb
  end
end
