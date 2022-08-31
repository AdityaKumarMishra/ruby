class AddPublicToTags < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :is_public, :boolean
    Tag.where(is_public: nil).update_all(is_public: false)
  end
end
