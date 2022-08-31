namespace :update_online_exam_percentile do
  task fetch_details: :environment do
    puts "=============== Percentile Task Start ==============="

      # Online Exam Percentile
      # assessment_attempts = AssessmentAttempt.where("assessable_type= 'OnlineExam' AND completed_at IS NOT NULL")
      # assessment_attempts.each do |assessment_attempt|
      #   assessment_attempt.section_attempts.order(:section_id).each do |sa|
      #     sa.calculate_percentile
      #   end
      #   assessment_attempt.online_exam_overall_percentile
      # end

      # Online Mock Exam Percentile
      # assessment_attempts = AssessmentAttempt.where("assessable_type = 'OnlineMockExam' AND completed_at IS NOT NULL")
      # assessment_attempts.each do |assessment_attempt|
      #   assessment_attempt.section_attempts.order(:section_id).each do |sa|
      #     sa.ome_section_percentile
      #   end
      #   if assessment_attempt.assessable.try(:per_city_exam_count) == 1
      #     assessment_attempt.ome1_overall_percentile
      #   else
      #     assessment_attempt.ome2_overall_percentile
      #   end
      # end

   puts "=============== Percentile Task End ==============="
  end
end
