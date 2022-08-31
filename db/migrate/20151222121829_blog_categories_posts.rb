class BlogCategoriesPosts < ActiveRecord::Migration[6.1]
  def change
    create_table :blog_categories_posts do |t|
      t.belongs_to :blog_category, index: true
      t.belongs_to :post, index: true
    end
  end
end
