class McqAttemptsController < ApplicationController
  before_action :authenticate_user!
  before_action :set_exercise, only: [:update_selected_attempt, :resolve_layout]
  before_action :set_service, only: [:update_answer,:update_mcq_answer, :update_attempt_answer]
  layout :resolve_layout

  def index
    service = McqAttemptService.new(params, current_user)
    @exercise, @ucat_course, @mcq_attempts, @question_time, @each_question_time, @selected_tab, request.cookies[:current_exe_atmpt] = service.index(cookies || request.cookies.symbolize_keys)
    cookies[:current_exe_atmpt] = request.cookies[:current_exe_atmpt] if cookies.present?
  end 
 
  def update_answer
    respond_to do |format|
      @exercise = @mcq_attempt_ans_service.update_answer(current_course)
      if session[:exercise_attempt].present?
        exercise = Exercise.find(session[:exercise_attempt])
        exercise.finish! if exercise.present?
        session[:exercise_attempt] = nil
      end
      if params[:mcq_attempts]
        cookies[:current_exe_atmpt] = nil
        format.html { redirect_to exercise_url(@exercise) }
        format.json { render json: @resource }
      else
        format.html do
          redirect_to exercise_mcq_attempts_url(@exercise),
                      error: 'Please attempt at least one question.'
        end
        format.json { render json: { error: 'Please attempt at least one question.' } }
      end
    end
  end

  def update_mcq_answer
    @result = @mcq_attempt_ans_service.update_mcq_answer(mcq_attempt_params)
  end

  def destroy
    @m_id, @success = @mcq_attempt_ans_service.destroy
  end

  def update_flagged
    respond_to do |format|
      mcq_attempt = McqAttempt.find_by(id: params[:id])
      if mcq_attempt.present? && mcq_attempt.update(flagged: !eval(params[:flagged]))
        format.json { render :json => mcq_attempt }
      else
        format.json { render json: false }
      end
    end
  end

  def update_selected_attempt
    @exercise = current_user.exercises.find_by(id: params[:exercise_id])
    respond_to do |format|
      if @exercise.present? && @exercise.update(selected_attempt: params[:selected_attempt])
        session[:tag_id] = params[:tag_id]
        format.json { render :json => true }
      else
        format.json { render json: false }
      end
    end
  end

  def get_question_list
    session[:tag_id] = params[:tag_id]
  end


  # for UCAT mcq attempts
  def update_attempt_answer
    respond_to do |format|
      mcq_attempt = McqAttempt.find_by(id: @params[:id])
      if mcq_attempt.present? && @params[:mcq_attempt_answeres].present?
        @mcq_attempt_ans_service.update_attempt_answer(mcq_attempt)
        format.json { render :json => true }
      else
        format.json { render :json => false }
      end
    end
  end

  private

  def mcq_attempt_params
    params.require(:mcq_attempt).permit!
  end

  def resolve_layout
    @exercise = current_user.exercises.find_by(id: params[:exercise_id]) if params[:exercise_id].present?
    if @exercise.present? && @exercise.course.product_version.product_line.name == 'umat'
      "layouts/ucat_exercise_dashboard"
    else
      "layouts/student_page"
    end
  end

  def set_service
    @mcq_attempt_ans_service = McqAttemptAnsService.new(params,current_user)
  end
end
