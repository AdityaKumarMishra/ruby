module OnlineMockExamAttemptTempsHelper
	def all_percentile_blank
		section3_percentile = nil
		if @online_mock_exam_attempt.essay_response.present? && @online_mock_exam_attempt.essay_response.essay_tutor_response.present?
			section3_percentile = @online_mock_exam_attempt.calculate_essay_percentile
		end
		if @section_attempts.pluck('percentile').include?(nil) ||  section3_percentile.blank?
			return true
		else
			return false
		end
	end
end
