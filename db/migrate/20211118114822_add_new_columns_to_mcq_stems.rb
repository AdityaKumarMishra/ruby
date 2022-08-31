class AddNewColumnsToMcqStems < ActiveRecord::Migration[6.1]
  def change
    add_column :mcq_stems, :status, :integer
    change_column :mcq_stems, :work_directory, :string
  end
end
