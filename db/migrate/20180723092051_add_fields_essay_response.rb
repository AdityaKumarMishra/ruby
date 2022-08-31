class AddFieldsEssayResponse < ActiveRecord::Migration[6.1]
  def up
    add_column :essay_responses, :old_tutor_id, :integer
  end

  def down
    remove_column :essay_responses, :old_tutor_id, :integer
  end
end
