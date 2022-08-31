class AddCourseIdToOrder < ActiveRecord::Migration[6.1]
  def change
    add_column :orders, :course_id, :integer
  end
end
