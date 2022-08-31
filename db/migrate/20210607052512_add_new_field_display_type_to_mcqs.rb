class AddNewFieldDisplayTypeToMcqs < ActiveRecord::Migration[6.1]
  def change
    add_column :mcqs, :display_type, :integer, default: 0
  end
end
