class CreateSkillTags < ActiveRecord::Migration[6.1]
  def change
    create_table :skill_tags do |t|
    	t.string :tag_name
      t.timestamps
    end
  end
end
