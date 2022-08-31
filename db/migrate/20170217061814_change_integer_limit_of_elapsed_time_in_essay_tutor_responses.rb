class ChangeIntegerLimitOfElapsedTimeInEssayTutorResponses < ActiveRecord::Migration[6.1]
  def change
  	 change_column :essay_responses, :elapsed_time, :integer, limit: 8
  end
end
