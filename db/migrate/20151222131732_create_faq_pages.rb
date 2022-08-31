class CreateFaqPages < ActiveRecord::Migration[6.1]
  def change
    create_table :faq_pages do |t|
      t.references :faq_topic, index: true, foreign_key: true
      t.text :content

      t.timestamps null: false
    end
  end
end
