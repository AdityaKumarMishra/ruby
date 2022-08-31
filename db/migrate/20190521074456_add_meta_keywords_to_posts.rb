class AddMetaKeywordsToPosts < ActiveRecord::Migration[6.1]
  def change
    add_column :posts, :meta_keywords, :text
  end
end
