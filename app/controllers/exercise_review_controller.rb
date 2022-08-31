class ExerciseReviewController < ApplicationController
  	before_action :authenticate_user!
  	before_action :mcq_exam_question_rating_params, only: [:create_update_question_rating]
  	before_action :set_service
  	layout :resolve_layout

	#reviw the exercise GET "/exercises/196179/mcq_attempts/review"
	def review
	    @exercise, @question, @selected_tab = @exercise_review_service.review
	    @mcq_attempts = if params[:question].present?
          policy_scope(McqAttempt).where(exercise: @exercise, mcq_stem_id: params[:question]).order(:id)
        else
          policy_scope(McqAttempt).where(exercise: @exercise).order(:id)
        end
	end

  	# Modal JS GET "/exercises/196179/mcq_attempts/3534190/mcq_exam_question_rating" rate the question in exercise by student
  	def mcq_exam_question_rating
  		@exercise, @mcq_attempt, @rating = @exercise_review_service.mcq_exam_question_rating
	    respond_to do |format|
	      format.html {render 'errors/not_found'}
	      format.js 
	    end
	end

	#POST "/exercises/196179/mcq_attempts/3534190/create_update_question_rating" on savig rating
	def create_update_question_rating
		@exercise, @mcq_attempt, @rating = @exercise_review_service.create_update_question_rating(mcq_exam_question_rating_params)
	    respond_to do |format|
	      format.html {render :nothing => true}
	      format.js
	    end
	end

  	# relevant videos for review
  	def exercise_review_videos
	    @exercise, @videos, @no_video_access, @type, @mcq_attempt = @exercise_review_service.exercise_review_videos
	    respond_to do |format|
	      format.html {render body: nil}
	      format.js
	    end
	end

	 #give feedback
	def give_feedback
	    @content = Mcq.find_by(id: params[:id])
	    @given = Exercise.find_by(id: params[:exercise_id])
	    respond_to do |format|
	      format.html {render :nothing => true}
	      format.js
	    end
	end

   # relevant textbook for review
  	def exercise_review_textbooks
	    @exercise, @mcq_attempt, @type, @textbooks, @no_textbook_access = @exercise_review_service.exercise_review_textbooks
	    respond_to do |format|
	      format.html {redirect_to "/404"}
	      format.js {render 'exercise_review_videos'}
	    end
	end

	private

	def mcq_exam_question_rating_params
    	params.require(:rate).permit!
  	end

  	def set_service
  		@exercise_review_service = ExerciseReviewService.new(params,current_user)
  	end

  	def resolve_layout
	    @exercise = current_user.exercises.find_by(id: params[:exercise_id]) if params[:exercise_id].present?
	    if @exercise.present? && @exercise.course.product_version.product_line.name == 'umat'
	      "layouts/ucat_exercise_dashboard"
	    else
	      "layouts/student_page"
	    end
  	end


end
