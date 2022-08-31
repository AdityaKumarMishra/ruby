class CreateVideoCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :video_categories do |t|
      t.string :name
      t.references :subject, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
