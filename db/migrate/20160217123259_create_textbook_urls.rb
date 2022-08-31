class CreateTextbookUrls < ActiveRecord::Migration[6.1]
  def change
    create_table :textbook_urls do |t|
      t.references :textbook
      t.references :user
      t.text :url

      t.timestamps null: false
    end
  end
end
