class CreateUserAnnouncements < ActiveRecord::Migration[6.1]
  def change
    create_table :user_announcements do |t|
      t.integer  :announcement_id
      t.boolean :viewed
      t.integer :user_id
      t.timestamps null: false
    end
  end
end
