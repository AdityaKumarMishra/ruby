class CreateManualEmailAnnouncements < ActiveRecord::Migration[6.1]
  def change
    create_table :manual_email_announcements do |t|
      t.string :greeting
      t.string :subject
      t.text :content
      t.timestamps null: false
    end
  end
end
