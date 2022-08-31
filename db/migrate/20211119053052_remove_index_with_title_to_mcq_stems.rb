class RemoveIndexWithTitleToMcqStems < ActiveRecord::Migration[6.1]
  def change
    remove_index :mcq_stems, :title
    add_index :mcq_stems, :title
  end
end
