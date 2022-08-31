class AddStartDateToCourseVersion < ActiveRecord::Migration[6.1]
  def change
    add_column :course_versions, :start_date, :datetime
  end
end
