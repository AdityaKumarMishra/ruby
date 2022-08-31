namespace :update_exams_percentile do
  task fetch_details: :environment do
    puts "=============== Exam Percentile Task Start ==============="

      #Online Exam Percentile
      assessment_attempts = AssessmentAttempt.where("assessable_type = 'OnlineExam' AND completed_at IS NOT NULL")
      assessment_attempts.each do |assessment_attempt|
        total_score = 0
        section1_score = 0
        section3_score = 0
        assessment_attempt.section_attempts.order(:section_id).each do |sa|
          # Update sections percentile
          sa.calculate_percentile

          total_count = sa.try(:section).try(:mcqs).try(:count)
          if (sa.section.title.include?("Section I") || sa.section.sectionable.title.include?("Section I")) &&  sa.section.position == 1
            section1_score = ((sa.mark/total_count.to_f) * 100).round(2)
          else
            section3_score = ((sa.mark/total_count.to_f) * 100).round(2)
          end
          total_score = (section1_score + 2 * section3_score).round(2)
        end

        assessment_attempt.update(section_one_score: section1_score, section_three_score: section3_score, total_score: total_score)

        # Update overall percentile
        assessment_attempt.overall_percentile
      end

      # Online Mock Exam Percentile
      assessment_attempts = AssessmentAttempt.where("assessable_type = 'OnlineMockExam' AND completed_at IS NOT NULL")
      assessment_attempts.each do |assessment_attempt|
        total_score = 0
        section1_score = 0
        section2_score = 0
        section3_score = 0
        if assessment_attempt.essay_response.present? && assessment_attempt.essay_response.essay_tutor_response.present?
          section2_score = ((assessment_attempt.essay_response.essay_tutor_response.rating.to_f / 80) * 100 ).round(2)
        end
        assessment_attempt.section_attempts.order(:section_id).each do |sa|
          OnlineMockExamService.calculate_section_percentile(sa)

          total_count = sa.try(:section).try(:mcqs).try(:count)
          if (sa.section.title.include?("Section I") || sa.section.sectionable.title.include?("Section I")) &&  sa.section.position == 1
            section1_score = ((sa.mark/total_count.to_f) * 100).round(2)
          else
            section3_score = ((sa.mark/total_count.to_f) * 100).round(2)
          end
          total_score = (section1_score + section2_score + 2 * section3_score).round(2)
        end

        assessment_attempt.update(section_one_score: section1_score, section_three_score: section3_score, total_score: total_score, section_two_score: section2_score)

        # Update overall percentile
        assessment_attempt.overall_percentile
      end

   puts "=============== Exam Percentile Task End ==============="
  end
end
