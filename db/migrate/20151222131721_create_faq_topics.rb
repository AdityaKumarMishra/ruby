class CreateFaqTopics < ActiveRecord::Migration[6.1]
  def up
    drop_table :faqs
    drop_table :faq_categories

  end

  def change
    create_table :faq_topics do |t|
      t.integer :faq_type
      t.string :code
      t.string :title

      t.timestamps null: false
    end

    add_column :faq_topics, :slug, :string, null: false
    add_index :faq_topics, :slug, :unique => true
  end

  def down
    create_table :faq_categories do |t|
      t.string :title

      t.timestamps null: false
    end

    create_table :faqs do |t|
      t.string :question
      t.string :answer
      t.boolean :is_published
      t.references :faq_category, index: true, foreign_key: true
      t.references :course, index: true, foreign_key: true

      t.timestamps null: false
    end
  end
end
