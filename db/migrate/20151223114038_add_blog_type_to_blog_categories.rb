class AddBlogTypeToBlogCategories < ActiveRecord::Migration[6.1]
  def change
    add_column :blog_categories, :blog_type, :integer
  end
end
