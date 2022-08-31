class ExamPercentileJob < ApplicationJob
  queue_as :default

  def perform(assessment_attempt)
    Rails.logger.info "=============== Exam Percentile Job Start ==============="
    if assessment_attempt.present? && assessment_attempt.assessable_type == "OnlineMockExam"
      assessment_attempts = AssessmentAttempt.where("assessable_type = 'OnlineMockExam' AND completed_at IS NOT NULL")
      assessment_attempts.each do |assessment_attempt|
        assessment_attempt.section_attempts.order(:section_id).each do |sa|
          sa.ome_section_percentile
        end
        if assessment_attempt.assessable.try(:per_city_exam_count) == 1
          assessment_attempt.ome1_overall_percentile
        else
          assessment_attempt.ome2_overall_percentile
        end
      end
    elsif assessment_attempt.present? && assessment_attempt.assessable_type == "OnlineExam"
      assessment_attempts = AssessmentAttempt.where("assessable_type = 'OnlineExam' AND completed_at IS NOT NULL")
      assessment_attempts.each do |assessment_attempt|
        assessment_attempt.section_attempts.order(:section_id).each do |sa|
          sa.calculate_percentile
        end
        assessment_attempt.online_exam_overall_percentile
      end
    end
    Rails.logger.info "=============== Exam Percentile Job End ==============="
  end
end
