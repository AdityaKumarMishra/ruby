class CreateContactForms < ActiveRecord::Migration[6.1]
  def change
    create_table :contact_forms do |t|
      t.string :email
      t.string :phone
      t.string :subject
      t.text :message
      t.references :contact_location, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
