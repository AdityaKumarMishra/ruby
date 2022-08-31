class AddNewFieldInstructionsToTags < ActiveRecord::Migration[6.1]
  def change
    add_column :tags, :instruction, :text
  end
end
