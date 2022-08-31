class RemoveFolderTaggableToTagging < ActiveRecord::Migration[6.1]
  def change
    remove_column :taggings, :folder_taggable_id, :integer
    remove_column :taggings, :folder_taggable_type, :string
    remove_column :tags, :type_name, :string, default: 'Tag'
  end
end
