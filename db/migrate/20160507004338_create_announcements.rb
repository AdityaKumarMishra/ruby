class CreateAnnouncements < ActiveRecord::Migration[6.1]
  def change
    create_table :announcements do |t|
      t.string :name
      t.text :description
      t.string :category

      t.timestamps null: false
    end
  end
end
