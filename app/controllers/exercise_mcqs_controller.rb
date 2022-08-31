class ExerciseMcqsController < ApplicationController
  layout 'layouts/mathjax'
  layout 'student_page'
  before_action :authenticate_user!
  before_action :set_exercise, only: [:repeat, :return_to_mcq]
  before_action :set_service, only: [:review_questions]

  def return_to_mcq
    mcq_attempts = @exercise.mcq_attempts.where(mcq_stem_id: params[:mcq_stem_id])
    mcq_attempts.each do |mcq_attempt|
      mcq_attempt.reset_mcq_statistics
    end
    if mcq_attempts.destroy_all
      @success = true
      @m_id = params[:mcq_stem_id]
    else
      @success = true
    end
  end

  def repeat
    @available_tags = current_user.current_feature_tags('McqFeature')
    authorize(@exercise)
    respond_to do |format|
      if @exercise.reset_mcq_attempts(current_course)
        format.html { redirect_to exercise_mcq_attempts_path(@exercise), notice: 'Exercise is reseted successfully.' }
        format.json { render :show, status: :created, location: @exercise }
      else
        format.html { render :new }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
      end
    end
  end

  def review_questions
    exercises = policy_scope(Exercise)
    @access_limit, @no_access, @amount, @mcq_partial_purchase, @purchase_mcqs, @more_access, @no_custom_access, @mcq_price, @p_course_path, @product_line, @condition_first, @left_questions = @exercise_review_service.review_exercise_questions(exercises, current_course)
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
  end

  private

  def set_exercise
    @exercise = current_user.exercises.find_by(id: params[:id])
    redirect_to dashboard_home_path and return unless @exercise.present?
  end

  def set_service
    @exercise_review_service = ExerciseReviewService.new(params, current_user)
  end

end
