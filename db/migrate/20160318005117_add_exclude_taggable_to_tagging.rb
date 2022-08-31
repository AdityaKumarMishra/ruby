class AddExcludeTaggableToTagging < ActiveRecord::Migration[6.1]
  def change
    add_reference :taggings, :exclude_taggable, polymorphic: true, index: true
  end
end
