class RemoveColsFromSectionItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :section_items, :essay_marking
    remove_column :section_items, :essay_id
  end
end
