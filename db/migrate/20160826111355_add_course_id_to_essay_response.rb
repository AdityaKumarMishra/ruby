class AddCourseIdToEssayResponse < ActiveRecord::Migration[6.1]
  def change
  	add_column :essay_responses, :course_id, :integer
  end
end
