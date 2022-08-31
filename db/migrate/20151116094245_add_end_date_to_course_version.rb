class AddEndDateToCourseVersion < ActiveRecord::Migration[6.1]
  def change
    add_column :course_versions, :end_date, :datetime
  end
end
