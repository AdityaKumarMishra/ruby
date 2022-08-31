class CreateFaqCategories < ActiveRecord::Migration[6.1]
  def change
    create_table :faq_categories do |t|
      t.string :title

      t.timestamps null: false
    end
  end
end
