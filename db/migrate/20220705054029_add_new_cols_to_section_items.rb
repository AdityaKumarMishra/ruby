class AddNewColsToSectionItems < ActiveRecord::Migration[6.1]
  def change
    add_column :section_items, :essay_id, :integer
  end
end
