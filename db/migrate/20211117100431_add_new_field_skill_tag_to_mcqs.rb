class AddNewFieldSkillTagToMcqs < ActiveRecord::Migration[6.1]
  def change
    add_column :mcqs, :skill_tags, :integer
  end
end
