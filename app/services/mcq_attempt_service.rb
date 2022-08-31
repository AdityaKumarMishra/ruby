class McqAttemptService < ApplicationService

	def initialize(params,current_user)
		@params = params
		@exercise = current_user.exercises.find_by(id: @params[:exercise_id])
		@current_user = current_user
	end

	def index(cookies)
	  if @exercise.present?
	    ucat_course = @exercise.course.product_version.product_line.name == 'umat'
	    mcq_attempts = @current_user.mcq_attempts.where(exercise: @exercise).order(:id)
	    question_time = @exercise.question_allotted_time
	    each_question_time = @exercise.time_per_question
	    selected_tab = @params[:mcq_stem]
	    cookies = set_cookies(cookies)
	  end
	  return @exercise, ucat_course, mcq_attempts, question_time, each_question_time, selected_tab, cookies["current_exe_atmpt"]
	end

	private

	def set_cookies(cookies)
	  cookies.delete :current_sa if !cookies[:current_sa].nil?
    begin
      cookies.delete :current_exe_atmpt if !cookies[:current_exe_atmpt].nil? && JSON.parse(cookies[:current_exe_atmpt])['id'] != @exercise.id
    rescue StandardError => e
      cookies.delete :current_exe_atmpt
    end
		if @exercise[:timer_option] == Exercise.timer_options["Timer"]
      if !cookies[:current_sa].nil? && JSON.parse(cookies[:current_exe_atmpt])['start'].try(:to_date)
        cookies.delete :current_sa
      end
      session[:exercise_attempt] = @exercise.id
      if cookies[:current_exe_atmpt].blank? or (cookies[:current_exe_atmpt] and JSON.parse(cookies[:current_exe_atmpt])['id'] != @exercise.id)

        end_time = @exercise.overall_time.present? ? @exercise.overall_time * 60 : 0 # duration; minutes > seconds

        serialized_value =  JSON.generate({
          id: @exercise.id,
          start: 0,
          end: end_time,
          url: request.fullpath,
          paused: false,
          mcq_stem: "",
          name: @exercise.name
        })
        # Set cookie with serialised value that expires at end time
        cookies[:current_exe_atmpt] = {
          value: serialized_value,
          expires: Time.zone.now + 30.days
        }
      end
    end
		return cookies
	end
end