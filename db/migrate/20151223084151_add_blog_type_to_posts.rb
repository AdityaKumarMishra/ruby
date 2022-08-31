class AddBlogTypeToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :blog_type, :integer
  end
end
