module Users
  class ResetMockExam
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
      msg = ''
      user = User.find(params[:user_id])
      live_exams = user.live_exams
      mock_exam_essay = user.mock_exam_essays
      if params[:section_type].present?
        if params[:section_type].eql?('section_1')
          live_exams.each do |live_exam|
            live_exam.update(section_one_score: 0, section_one_percentile: 0.0)
          end
        end

        if params[:section_type].eql?('section_3')
          live_exams.each do |live_exam|
            live_exam.update(section_three_score: 0, section_three_percentile: 0.0)
          end
        end

        if params[:section_type].eql?('section_2')
          mock_exam_essay.destroy_all if mock_exam_essay.present?
          live_exams.each do |live_exam|
            live_exam.update(section_two_score: 0, section_two_percentile: 0.0)
          end
        end
        msg = 'Mock Exam was reset successfully.'
      else
        live_exams.destroy_all if live_exams.present?
        mock_exam_essay.destroy_all if mock_exam_essay.present?
        msg = 'Mock Exam was reset successfully.'
      end

      msg
    end
  end
end
