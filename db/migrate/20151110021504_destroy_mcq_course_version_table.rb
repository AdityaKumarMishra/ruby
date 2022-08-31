class DestroyMcqCourseVersionTable < ActiveRecord::Migration[6.1]
  def change
    drop_table :mcq_course_versions
  end
end
