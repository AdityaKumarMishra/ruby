class AddNewFieldsToMcqStems < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :pool, :integer
    add_column :mcq_stems, :work_status, :integer, default: 0
    add_column :mcq_stems, :reviewer2_id, :integer
    add_column :mcq_stems, :graphics_required, :boolean, default: false
    add_column :mcq_stems, :work_directory, :text
  end
end
