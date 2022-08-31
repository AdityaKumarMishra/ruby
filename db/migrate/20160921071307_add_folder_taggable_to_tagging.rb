class AddFolderTaggableToTagging < ActiveRecord::Migration[6.1]
  def change
    add_column :taggings, :folder_taggable_id, :integer
    add_column :taggings, :folder_taggable_type, :string
  end
end
