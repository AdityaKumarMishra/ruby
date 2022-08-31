class RemoveMcqStemIdFromSectionItems < ActiveRecord::Migration[6.1]
  def change
    remove_column :section_items, :mcq_stem_id, :integer
  end
end
