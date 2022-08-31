class AddElapsedTimeToEssayTutorResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :essay_tutor_responses, :elapsed_time, :integer, default: 0, null: false
  end
end
