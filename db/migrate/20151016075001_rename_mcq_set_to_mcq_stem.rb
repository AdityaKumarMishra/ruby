class RenameMcqSetToMcqStem < ActiveRecord::Migration[6.1]
  def up
    rename_table :mcq_sets, :mcq_stems
    rename_column :mcqs, :mcq_set_id, :mcq_stem_id
  end

  def down
    rename_table :mcq_stems, :mcq_sets
    rename_column :mcqs, :mcq_stem_id, :mcq_set_id
  end
end
