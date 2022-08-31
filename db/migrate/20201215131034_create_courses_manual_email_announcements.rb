class CreateCoursesManualEmailAnnouncements < ActiveRecord::Migration[6.1]
  def change
    create_table :courses_manual_email_announcements do |t|
      t.integer :course_id
      t.integer :manual_email_announcement_id
    end
  end
end
