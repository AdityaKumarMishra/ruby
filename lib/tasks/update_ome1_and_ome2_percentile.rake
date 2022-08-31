namespace :update_ome1_and_ome2_percentile do
  task fetch_details: :environment do
    puts "=============== Task Start ==============="
      assessment_attempts = AssessmentAttempt.where("assessable_type= 'OnlineMockExam'AND completed_at IS NOT NULL")
      count = 0
      assessment_attempts.each do |assessment_attempt|
        assessment_attempt.section_attempts.order(:section_id).each do |sa|
          sa.ome_section_percentile
        end
        if assessment_attempt.assessable.try(:per_city_exam_count) == 1
          assessment_attempt.calculate_overall_percentile
        else
          assessment_attempt.ome2_overall_percentile
        end
        puts assessment_attempt.user.try(:email)
        count = count + 1
      end
      puts count
    puts "=============== Task End ==============="
  end
end
