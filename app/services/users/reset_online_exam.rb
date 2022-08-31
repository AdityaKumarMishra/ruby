module Users
  class ResetOnlineExam
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
      if params[:exam_id].present?
        exam = AssessmentAttempt.find(params[:exam_id])
        exam.destroy
        msg = 'OnlineExam was reset successfully.'
      else
        user = User.find(params[:user_id])
        en = Enrolment.find_by(id: params[:enrolment_id])
        course_id = en.course_id
        exams = user.assessment_attempts.where(assessable_type: "OnlineExam", course_id: course_id)
        exams.destroy_all
        msg = 'OnlineExams was reset successfully.'
      end

      msg
    end
  end
end
