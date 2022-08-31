class RemoveTitleFromMcq < ActiveRecord::Migration[6.1]
  def change
    remove_column :mcqs, :title
  end
end
