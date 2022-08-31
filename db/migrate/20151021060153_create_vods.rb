class CreateVods < ActiveRecord::Migration[6.1]
  def change
    create_table :vods do |t|
      t.string :title
      t.datetime :date_published
      t.boolean :published
      t.integer :viewcount
      t.attachment :video

      t.timestamps null: false
    end
  end
end
