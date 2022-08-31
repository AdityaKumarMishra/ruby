class AddSkillTagIdMcqs < ActiveRecord::Migration[6.1]
  def change
  	add_column :mcq_stems, :skill_tag_id, :integer
  	add_column :mcqs, :skill_tag_id, :integer
  end
end
