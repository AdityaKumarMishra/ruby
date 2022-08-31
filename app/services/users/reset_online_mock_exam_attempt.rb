module Users
  class ResetOnlineMockExamAttempt
    attr_accessor :params

    def initialize(params)
      @params = params
    end

    class << self
      def call(params)
        new(params).call
      end
    end

    def call
      if params[:online_mock_exam_at_id].present?
        online_mock_exam_attempt = AssessmentAttempt.find(params[:online_mock_exam_at_id])
        online_mock_exam_attempt.destroy
        msg = 'OnlineMockExamAttempt was reset successfully.'
      else
        user = User.find(params[:user_id])
        online_mock_exam_attempt = user.assessment_attempts.where(assessable_type: "OnlineMockExam")
        online_mock_exam_attempt.destroy_all
        msg = 'OnlineMockExamAttempts was reset successfully.'
      end

      msg
    end
  end
end
