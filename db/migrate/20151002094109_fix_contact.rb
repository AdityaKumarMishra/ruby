class FixContact < ActiveRecord::Migration[6.1]
  def up
    remove_column :contacts, :city
    add_reference :contacts, :contact_location, index: true, foreign_key: true
  end

  def down
    add_column :contacts, :city, :string
    remove_reference :contacts, :contact_location, index: true, foreign_key: true
  end
end
