class AddLastEditedByToMcqStem < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :last_editor_id, :integer
  end
end
