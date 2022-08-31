class AddElapsedTimeToEssayResponse < ActiveRecord::Migration[6.1]
  def change
    add_column :essay_responses, :elapsed_time, :int, default: 0
  end
end
