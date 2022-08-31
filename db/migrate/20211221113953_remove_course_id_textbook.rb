class RemoveCourseIdTextbook < ActiveRecord::Migration[6.1]
  def change
  	remove_column :textbook_reads, :course_id
  end
end
