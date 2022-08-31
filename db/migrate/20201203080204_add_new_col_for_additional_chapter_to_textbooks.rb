class AddNewColForAdditionalChapterToTextbooks < ActiveRecord::Migration[6.1]
  def change
    add_column :textbooks, :for_additional_chapter, :boolean, default: :false
  end
end
