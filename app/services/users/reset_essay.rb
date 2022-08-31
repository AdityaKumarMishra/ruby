module Users
  class ResetEssay
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
      expire_date = params[:expiry_date].in_time_zone("Australia/Queensland") + 23.hours + 59.minutes
      msg = ''
      if params[:essay_response_id].present?
        essay_response = EssayResponse.find(params[:essay_response_id])
        if essay_response.expiry_date < Time.zone.now.in_time_zone("Australia/Queensland")
          essay_response.update(elapsed_time: 0, time_submited: nil, expiry_date: expire_date, status: 'unanswered')
        else
          essay_response.update(expiry_date: expire_date, status: 'unanswered', time_submited: nil)
        end
        msg = 'Essay was reset successfully.'
        essay_response.essay_tutor_response.destroy if essay_response.essay_tutor_response.present?
      else
        user = User.find(params[:user_id])
        en = Enrolment.find_by(id: params[:enrolment_id])
        course_id = en.course_id
        essay_responses = user.essay_responses.where(course_id: course_id)
        essay_responses.each do |essay_response|
          if essay_response.expiry_date < Time.zone.now.in_time_zone("Australia/Queensland")
            essay_response.update(elapsed_time: 0, time_submited: nil, expiry_date: expire_date, status: 'unanswered')
          else
            essay_response.update(expiry_date: expire_date, status: 'unanswered', time_submited: nil)
          end
          essay_response.essay_tutor_response.destroy if essay_response.essay_tutor_response.present?
        end
        msg = 'Essay was reset successfully.'
      end

      msg
    end
  end
end
