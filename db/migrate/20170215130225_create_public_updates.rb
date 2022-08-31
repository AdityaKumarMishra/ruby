class CreatePublicUpdates < ActiveRecord::Migration[6.1]
  def change
    create_table :public_updates do |t|

      t.timestamps null: false
      t.string :contact_number
    end
  end
end
