class AddFlaggedToMcqAttempt < ActiveRecord::Migration[6.1]
  def change
  	add_column :mcq_attempts, :flagged, :boolean, deafult: false
  	add_column :exercises, :selected_attempt, :string
  end
end
