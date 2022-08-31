namespace :enrolments do
  task :add_attempts,[:exam_id, :mock_exam_id] => :environment do |t, args|
    online_mock_exam = OnlineMockExam.find_by(id: args.mock_exam_id.to_i)
    online_exam = OnlineExam.find_by(id: args.exam_id.to_i)
    a_attempts = online_mock_exam.assessment_attempts.completed.order(completed_at: :desc)
    a_attempts.each do |a_attempt|
      new_attempt = AssessmentAttempt.new(a_attempt.dup.as_json.except("section_two_percentile", "total_score", "percentile"))
      new_attempt.assessable_id = online_exam.id
      new_attempt.assessable_type = "OnlineExam"
      new_attempt.copy_id = a_attempt.id
      a_attempt.section_attempts.order(:section_id).each do |sa|
        if ((sa.section.title.include?("Section I") || sa.section.sectionable.title.include?("Section I")) &&  sa.section.position == 1) || !((sa.section.title.include?("Section I") || sa.section.sectionable.title.include?("Section I")) &&  sa.section.position == 1)
          new_sa_attempt = new_attempt.section_attempts.new(sa.dup.as_json.except("assessment_attempt_id", "total_score", "percentile"))
          sa.section_item_attempts.each do |sia|
            new_sa_item_attempt = new_sa_attempt.section_item_attempts.new(sia.dup.as_json.except("section_attempt_id"))
          end
        end
      end
      begin
        AssessmentAttempt.skip_callback(:create, :after, :create_section_attempts)
        AssessmentAttempt.skip_callback(:create, :after, :create_online_mock_exam_online_exam)
        SectionAttempt.skip_callback(:create, :after, :create_section_item_attempts)
      rescue
        puts 'no callback'
      end
      new_attempt.save!
    end
    AssessmentAttempt.set_callback(:create, :after, :create_section_attempts)
    AssessmentAttempt.set_callback(:create, :after, :create_online_mock_exam_online_exam)
    SectionAttempt.set_callback(:create, :after, :create_section_item_attempts)
  end
end