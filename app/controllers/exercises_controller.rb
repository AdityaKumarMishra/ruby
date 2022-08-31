class ExercisesController < ApplicationController
  layout 'layouts/mathjax'
  layout :resolve_layout
  before_action :authenticate_user!
  before_action :set_exercise, only: [:show, :edit, :update, :destroy]
  before_action :set_service, only: [:new]

  def index
    @exercises = policy_scope(Exercise)
    @exercises = @exercises.order(completed_at: :desc)
    mcq_stems = McqStem.includes(:mcq_attempts).where(mcq_attempts: {id: McqAttempt.where(exercise_id: @exercises.ids).ids})
    @filterrific = initialize_filterrific(
      mcq_stems,
      params[:filterrific],
    ) || return
    if params[:filterrific].present? && params[:filterrific][:search_query].present?
      @mcq_stems = @filterrific.find
      @s_query = true
    else
      @s_query = false
    end
  end

  def new
    if current_user.student? && !current_user.questionnaire.present?
      given_exercises = policy_scope(Exercise)
      mcqs_count = Mcq.includes(:mcq_attempts).where(mcq_attempts: {id: McqAttempt.where(exercise_id: given_exercises.ids).ids}).count
      current_user.update_feature_access_count
      redirect_to dashboard_home_path(update_background: true) and return if current_user.feature_access_count > 3 || mcqs_count > 20
    end
    @announcement, @user_announcement, @exercise, @taggings, @available_tags, @course = @exercise_service.exercise_new(current_course)
    authorize @exercise
  end

  def create
    @course = current_course
    cookies.delete :current_sa if !cookies[:current_sa].nil?
    cookies.delete :current_exe_atmpt if !cookies[:current_exe_atmpt].nil?
    @exercise = current_user.exercises.build(exercise_params)
    @available_tags = current_user.current_feature_tags('McqFeature')
    respond_to do |format|
      if @exercise.save
        @exercise.update_attribute(:timer_option_type, nil) if @exercise.overall_time.nil?
        format.html { redirect_to exercise_mcq_attempts_path(@exercise), notice: 'Exercise was successfully created.' }
        format.json { render :show, status: :created, location: @exercise }
      else
        format.html { render :new }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def update
    respond_to do |format|
      if @exercise.update(exercise_params)
        format.html { redirect_to @exercise, notice: 'Exercise was successfully updated.' }
        format.json { render :show, status: :ok, location: @exercise }
      else
        format.html { render :edit }
        format.json { render json: @exercise.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def destroy
    @exercise.update_mcq_statistics_with_delete(current_course) if @exercise.completed_at.present?
    @exercise.destroy
    respond_to do |format|
      format.html { redirect_to exercises_url, notice: 'Exercise was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_exercise
    @exercise = current_user.exercises.find_by(id: params[:id])
    redirect_to dashboard_home_path and return unless @exercise.present?
  end

  def exercise_params
    params.require(:exercise).permit(:name, :timer_option, :overall_time, :difficulty, :amount, :question_style, :timer_option_type, :course_id,  tag_ids: [])
  end

  def resolve_layout
    'student_page'
  end

  def set_service
    @exercise_service = ExerciseService.new(params, current_user)
  end
end
