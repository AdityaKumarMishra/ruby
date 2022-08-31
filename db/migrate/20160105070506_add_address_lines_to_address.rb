class AddAddressLinesToAddress < ActiveRecord::Migration[6.1]
  def change
    add_column :addresses, :line_one, :text
    add_column :addresses, :line_two, :text
  end
end
