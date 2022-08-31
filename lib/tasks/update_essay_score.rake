namespace :update_essays_score do
  task update_score: :environment do
    puts "=============== Essay Percentile Task Start ==============="
    assessment_attempts = AssessmentAttempt.where("assessable_type = 'OnlineMockExam' AND completed_at IS NOT NULL")
      assessment_attempts.each do |assessment_attempt|
        essay_mark = assessment_attempt.essay_response.present? && assessment_attempt.essay_response.essay_tutor_response.present? ? assessment_attempt.essay_response.essay_tutor_response.rating.to_i : 0
        assessment_attempt.update(section_two_raw_score: essay_mark)
      end
    puts "=============== Essay Percentile Task Start ==============="
  end

  task update_percentile: :environment do
    puts "=============== Essay Percentile Task Start ==============="
    assessment_attempts = AssessmentAttempt.where("assessable_type = 'OnlineMockExam' AND completed_at IS NOT NULL")
      assessment_attempts.each do |assessment_attempt|
        assessment_attempt.calculate_essay_percentile
      end
    puts "=============== Essay Percentile Task Start ==============="
  end
end
