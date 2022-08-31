class CreateCoursesEmailCustomises < ActiveRecord::Migration[6.1]
  def change
    create_table :courses_email_customises do |t|
    	t.integer :course_id
    	t.integer :email_customise_id
    end
  end
end
