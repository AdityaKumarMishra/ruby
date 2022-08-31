class SectionItemAttemptsController < ApplicationController
  layout 'layouts/mathjax'
  layout 'layouts/student_page'
  before_action :authenticate_user!
  before_action :set_attemptable
  before_action :mcq_exam_question_rating_params, only: [:create_update_question_rating]
  before_action :set_section_attempt

  def index
    cookies.delete :current_sa if !cookies[:current_sa].nil? && JSON.parse(cookies[:current_sa])['id'] != @section_attempt.id
    cookies.delete :current_exe_atmpt if !cookies[:current_exe_atmpt].nil?
    @section_item_attempts = @section_attempt.section_item_attempts
    @sorted_mcq_stems = @section_attempt.mcq_stems.uniq.sort_by{|s| s.to_s.scan(/\d+/).map{|s| s.to_i}}
    @selected_tab = params[:mcq_stem]
    session[:section_attempt] = @section_attempt.id
    @question_time = @section_attempt.question_allotted_time
    assessment_type = AssessmentAttempt.find(@section_attempt.assessment_attempt_id).assessable_type
    unless @section_attempt.assessment_attempt.assessable.try(:is_finish).present?
      is_finished = false
    else
      is_finished = @section_attempt.assessment_attempt.assessable.is_finish
    end
    if cookies[:current_sa].blank? or (cookies[:current_sa] and JSON.parse(cookies[:current_sa])['id'] != @section_attempt.id)
      end_time = @section_attempt.section.duration.present? ? @section_attempt.section.duration * 60 : 0 # duration; minutes > seconds
      serialized_value =  JSON.generate({
        id: @section_attempt.id,
        exam_finish: is_finished,
        time_elapsed: 0,
        end: end_time,
        url: request.fullpath,
        paused: false,
        mcq_stem: "",
        name: assessment_type
      })
      # Set cookie with serialised value that expires at end time
      cookies[:current_sa] = {
        value: serialized_value,
        expires: Time.zone.now + 30.days
      }
    end
  end

  def review
    if params[:ticket_id].present?
      ticket = Ticket.find_by(id: params[:ticket_id])
      if @section_attempt.assessment_attempt.question_style.eql?(0)
        @selected_tab = ticket.try(:questionable).try(:mcq_stem)
      else
        @selected_tab = ticket.try(:questionable)
      end
    end
    # authorize @section_attempt, :review?
    @section_item_attempts = @section_attempt.section_item_attempts
    @sorted_mcq_stems = @section_attempt.mcq_stems.uniq.sort_by{|s| s.to_s.scan(/\d+/).map{|s| s.to_i}}

  end

  def complete
    authorize @section_attempt
    if !params[:section_item_attempts].nil?
      @section_attempt.section_item_attempts.update(params[:section_item_attempts].keys,
                                                    params[:section_item_attempts].values)
    end

    if @section_attempt.completed!
      @section_attempt.update_exam_statistics(current_course.try(:id))
    end
    # if @section_attempt.present? && @section_attempt.assessment_attempt.present? && @section_attempt.assessment_attempt.completed_at.present?
    #   ExamPercentileJob.perform_later(@section_attempt.assessment_attempt)
    # end
    cookies.delete :current_sa if !cookies[:current_sa].nil?
    respond_to do |format|

      if @section_attempt.assessment_attempt.assessable.class == OnlineExam
        path = online_exam_attempt_path(@attemptable)
      elsif @section_attempt.assessment_attempt.assessable.class == DiagnosticTest
        path = diagnostic_test_attempt_path(@attemptable)
      elsif @section_attempt.assessment_attempt.assessable.class == OnlineMockExam
        if @section_attempt.assessment_attempt.assessable.per_city_exam_count > 1
          path = online_mock_exam_attempts_path
        else
          path = online_mock_exam_attempt_temps_path
        end
        #path = online_mock_exam_attempts_path
      end
      format.html { redirect_to path }
      format.json { render json: @section_attempt }
    end
  end

  def update_answer
    result = false
    if !params[:section_item_attempts].nil?
      if @section_attempt.section_item_attempts.update(section_item_attempt_params.keys, section_item_attempt_params.values)
        result = true
      end
    end
    render text: result
  end

  def exam_review_videos
    @section_item_attempt = SectionItemAttempt.find(params[:id])
    if current_user.has_video_feature
      tags = current_user.current_feature_tags('VideoFeature') & @section_item_attempt.mcq.tags
      @videos = Vod.by_tags(tags)
    else
      @no_video_access = true
    end
    @type = 'Videos'
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
  end

  def exam_review_textbooks
    @section_item_attempt = SectionItemAttempt.find(params[:id])
    if current_user.has_textbook_feature
      tags = current_user.current_feature_tags('TextbookFeature') & @section_item_attempt.mcq.tags
      @textbooks = Textbook.by_tags(tags)
    else
      @no_textbook_access = true
    end
    @type = 'Textbooks'
    respond_to do |format|
      format.html {render :nothing => true}
      format.js{render 'exam_review_videos'}
    end
  end

  def mcq_exam_question_rating
    @item_attempt = SectionItemAttempt.find(params[:id])
    stem = @item_attempt.mcq_stem
    @rating = stem.rates.find_by(rater_id: current_user.id)
    @rating = stem.rates.new if @rating.nil?
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
  end

  def create_update_question_rating
    @item_attempt = SectionItemAttempt.find(params[:id])
    stem = @item_attempt.mcq_stem
    @rating = stem.rates.find_by(rater_id: current_user.id)
    if @rating.nil?
      mcq_exam_question_rating_params[:stars] = 0.0
      mcq_exam_question_rating_params[:rater_id] = current_user.id
      @rating = stem.rates.create(mcq_exam_question_rating_params)
    else
      @rating.update(mcq_exam_question_rating_params)
    end
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
  end

  def exam_feedback
    @content = SectionItemAttempt.find(params[:id]).mcq
    @given = SectionAttempt.find(params[:section_attempt_id])
    respond_to do |format|
      format.html {render :nothing => true}
      format.js
    end
  end

  private

  def set_attemptable
    if params[:online_exam_attempt_id]
      @online_exam_attempt = current_user.online_exam_attempts.find_by(id: params[:online_exam_attempt_id])
      @attemptable = @online_exam_attempt
    elsif params[:diagnostic_test_attempt_id]
      @diagnostic_test_attempt = current_user.diagnostic_test_attempts.find_by(id: params[:diagnostic_test_attempt_id])
      @attemptable = @diagnostic_test_attempt
    elsif params[:online_mock_exam_attempt_id]
      @online_mock_exam_attempt = current_user.online_mock_exam_attempts.find_by(id: params[:online_mock_exam_attempt_id])
      @attemptable = @online_mock_exam_attempt
    elsif params[:online_mock_exam_attempt_temp_id]
      @online_mock_exam_attempt = current_user.online_mock_exam_attempts.find_by(id: params[:online_mock_exam_attempt_temp_id])
      @attemptable = @online_mock_exam_attempt
    end
  end

  def set_section_attempt
    @section_attempt = @attemptable.section_attempts.find_by(id: params[:section_attempt_id]) if @online_exam_attempt || @diagnostic_test_attempt || @online_mock_exam_attempt
  end

  def section_item_attempt_params
    params.require(:section_item_attempts).permit!
  end

  def mcq_exam_question_rating_params
    params.require(:rate).permit!
  end
end
