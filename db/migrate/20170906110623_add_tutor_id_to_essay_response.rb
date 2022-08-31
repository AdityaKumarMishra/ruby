class AddTutorIdToEssayResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :essay_responses, :tutor_id, :integer
  end
end
