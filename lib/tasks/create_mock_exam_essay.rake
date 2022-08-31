namespace :create_mock_exam_essay do
  desc "Create mock exam essay"
  task mock_exam_essay: :environment do
    FeatureLog.includes(:master_feature, enrolment: :course).where('acquired IS NOT NULL AND master_features.name LIKE?', '%LiveExamFeature%').references(:master_features).each do |feature|
      course = feature.course
      user = feature.user
      if course.present? && course.staff_profiles.present? && user.present?
        tutor_id = course.staff_profiles.first.staff.id
        mock_exam_essay = MockExamEssay.find_or_create_by(course_id: course.id, user_id: user.id)
        mock_exam_essay.assigned_tutors = [tutor_id]
        mock_exam_essay.save
      end
    end
  end
end
