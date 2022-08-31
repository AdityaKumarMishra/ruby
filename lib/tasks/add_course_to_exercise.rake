namespace :add_course_to_exercise do
  desc "Add Course ID to exercise and exams for old data"
  task add_course_id: :environment do
    # Add course id for exercises
    User.student.each do |user|
      next if user.exercises.blank?
      if user.active_courses.count > 1
        beg_of_day = Time.zone.now.beginning_of_day
        en_ids = user.enrolments.includes(:course).where("((trial = ? AND trial_expiry < ?) OR (courses.expiry_date < ?)) AND state != ?", true, beg_of_day, beg_of_day, Enrolment.states['Unenrolled']).references(:courses)
        act_courses = user.active_courses.includes(:enrolments).where.not(enrolments: {id: en_ids})
        if act_courses.present?
          act_courses.each do |course|
            user.active_course = course
            course_tag_ids = user.current_course_tags.map(&:id)
            exercises = user.exercises.includes(:tags).where(tags: { id: course_tag_ids })
            Exercise.where(id: exercises.ids).update_all(course_id: course.id)
          end
        else
          course_id = user.active_courses.first
          user.exercises.update_all(course_id: course_id)
        end
      else
        course_id = user.active_courses.first
        user.exercises.update_all(course_id: course_id)
      end
    end

    # Add course id for assesment attempts
    User.student.each do |user|
      next if user.assessment_attempts.blank?
      if user.active_courses.count > 1
        beg_of_day = Time.zone.now.beginning_of_day
        en_ids = user.enrolments.includes(:course).where("((trial = ? AND trial_expiry < ?) OR (courses.expiry_date < ?)) AND state != ?", true, beg_of_day, beg_of_day, Enrolment.states['Unenrolled']).references(:courses)
        act_courses = user.active_courses.includes(:enrolments).where.not(enrolments: {id: en_ids})
        if act_courses.present?
          act_courses.each do |course|
            user.active_course = course
            course_tag_ids = user.current_course_tags.map(&:id)
            exam_attempts = user.assessment_attempts.where(assessable_type: 'OnlineExam').includes(online_exam: :tags).where(tags: { id: course_tag_ids })
            diagonstic_attempts  = user.assessment_attempts.where(assessable_type: 'DiagnosticTest').includes(diagnostic_test: :tags).where(tags: { id: course_tag_ids })
            AssessmentAttempt.where(id: exam_attempts.ids).update_all(course_id: course.id)
            AssessmentAttempt.where(id: diagonstic_attempts.ids).update_all(course_id: course.id)
          end
        else
          course_id = user.active_courses.first
          user.assessment_attempts.update_all(course_id: course_id)
        end
      else
        course_id = user.active_courses.first
        user.assessment_attempts.update_all(course_id: course_id)
      end
    end
  end
end
