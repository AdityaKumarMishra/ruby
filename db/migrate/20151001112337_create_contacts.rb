class CreateContacts < ActiveRecord::Migration[6.1]
  def up
    create_table :contacts do |t|
      t.string  :city
      t.string  :name
      t.string  :position
      t.string  :email
      t.boolean :visible
      t.timestamps null: false
    end
    add_attachment :contacts, :avatar
  end

  def down
    drop_table :contacts
  end
end
