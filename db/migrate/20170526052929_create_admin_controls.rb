class CreateAdminControls < ActiveRecord::Migration[6.1]
  def change
    create_table :admin_controls do |t|
      t.string :name
      t.boolean :new_view
      t.timestamps null: false
    end
    AdminControl.create(name: 'Signup view', new_view: true)
  end
end
