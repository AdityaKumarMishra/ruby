class AddTitleToMcqs < ActiveRecord::Migration[6.1]
  def change
    add_column :mcqs, :title, :string
  end
end
