class CreateWaitlistUsers < ActiveRecord::Migration[6.1]
  def change
    create_table :waitlist_users do |t|
      t.string :name
      t.string :email
      t.references :course, null: false, foreign_key: true

      t.timestamps
    end
  end
end
