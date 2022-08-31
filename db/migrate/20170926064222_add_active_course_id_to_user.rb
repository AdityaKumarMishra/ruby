class AddActiveCourseIdToUser < ActiveRecord::Migration[6.1]
  def change
    add_column :users, :active_course_id, :integer
  end
end
