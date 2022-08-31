namespace :add_active_course_to_user do
  task add_active_course_id_to_user: :environment do
    User.student.each do |user|
      begin
        if user.active_enrolled_courses.present?
          if user.update_attribute(:active_course_id, user.active_enrolled_courses.first.id)
          else
            puts "Error in ============ #{user.email}"
          end
        end
      rescue Exception => e
        puts "Error in ============ #{user.email}"
      end
    end
  end
end
