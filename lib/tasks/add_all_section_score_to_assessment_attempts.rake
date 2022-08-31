namespace :add_all_section_score_to_assessment_attempts do
  task fetch_details: :environment do
    puts "=============== Task Start ==============="
      ome1_ids = OnlineMockExam.where(published: true, per_city_exam_count: 1).pluck(:id)
      assessment_attempts = AssessmentAttempt.where("assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineMockExam' AND assessment_attempts.completed_at IS NOT NULL", ome1_ids)
      count = 0
      assessment_attempts.each do |assessment_attempt|
        if assessment_attempt.essay_response.present? && assessment_attempt.essay_response.essay_tutor_response.present?
          total_marks = assessment_attempt.essay_response.essay_tutor_response.rating.try(:to_i) + assessment_attempt.mark
          assessment_attempt.update(all_section_score: total_marks)
          count = count + 1
        end
      end
      puts count
    puts "=============== Task End ==============="
  end
end
