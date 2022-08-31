class OnlineMockExamAttemptTempsController < ApplicationController
  layout 'layouts/mathjax'
  layout "layouts/student_page"
  before_action :authenticate_user!
  before_action :set_online_mock_exam_attempt, only: [:show, :edit, :update, :destroy]
  before_action :set_online_mock_exam, only: [:index, :create]
  before_action :set_sections, only: [:index]

  def index
    if current_user.student? && !current_user.questionnaire.present?
      current_user.update_feature_access_count
      redirect_to dashboard_home_path(update_background: true) and return if current_user.feature_access_count > 3
    end
    master_feature = current_user.accessible_features.find_by("name LIKE?", '%OnlineMockExamFeature%')
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end
    @online_mock_exam_attempt = current_user.online_mock_exam_attempts.find_by(course_id: current_course.id, assessable_id: @online_mock_exam.id) if @online_mock_exam.present?
    @essays_responses = []
    @essays_responses << @online_mock_exam_attempt.try(:essay_response)
    unless @online_mock_exam_attempt.nil?
      authorize(@online_mock_exam_attempt, :online_mock_exams_index?)
    end
    if master_feature.online_mock_exam?
      feature_acquired = current_user.accessible_features.find_by("name LIKE?", '%OnlineMockExamFeature1%')
      if feature_acquired.blank?
        mock_exam = current_course.master_features.where("master_features.name LIKE?", '%OnlineMockExamFeature1%').first
        redirect_to dashboard_no_access_path(feature_type: mock_exam.id)
      end
    end
  end

  def refresh_document
    @document = OnlineMockExamSection.find(params[:document_id])
    @online_mock_exam_attempt = AssessmentAttempt.find(params[:attempt_id]) if params[:attempt_id].present?
    @essays_responses = []
    @essays_responses <<  AssessmentAttempt.find(params[:attempt_id]).try(:essay_response) if params[:attempt_id].present?
    respond_to do |format|
      format.html{}
      format.js{}
    end
  end

  def show
    if @online_mock_exam_attempt.course_id != current_course.try(:id)
      redirect_to online_mock_exam_attempt_temps_path
    end
  end

  def new
    @course = current_course
    @online_mock_exam_attempt = current_user.online_mock_exam_attempts.new
  end

  def create
    @current_course = current_user.active_course
    online_mock_exam_attempt = current_user.online_mock_exam_attempts.find_by(course_id: current_course.id, assessable_id: @online_mock_exam.id)
    @online_mock_exam_attempt = online_mock_exam_attempt.nil? ? current_user.online_mock_exam_attempts.new : online_mock_exam_attempt
    respond_to do |format|
      if online_mock_exam_attempt.nil? && @online_mock_exam.valid_attempt_to_create?
        @online_mock_exam_attempt.assessable_id = @online_mock_exam.id
        @online_mock_exam_attempt.assessable_type = "OnlineMockExam"
        @online_mock_exam_attempt.course_id = @current_course.id
        @online_mock_exam_attempt.timer_option_type = "entire_exam"
        if @online_mock_exam_attempt.save
          format.html { redirect_to online_mock_exam_attempt_temps_path, notice: 'Online Mock Exam Attempt was successfully created.' }
          format.json { render :show, status: :created, location: @online_mock_exam_attempt }
        else
          format.html { redirect_to online_mock_exam_attempt_temps_path }
          format.json { render json: @online_mock_exam_attempt.errors, status: :unprocessable_entity }
          flash[:error] = 'Online Mock Exam Attempt was Already Created'
        end
      else
        @online_mock_exam_attempt.update(online_mock_exam_attempt_params) unless online_mock_exam_attempt.nil?
        @online_mock_exam_attempt.update_attribute(:completed_at, Time.zone.now) if @online_mock_exam_attempt.all_sections_completed
        format.html { redirect_to online_mock_exam_attempt_temps_path, notice: "Score saved successfully"}
        format.json { render json: @online_mock_exam_attempt.errors, status: :unprocessable_entity }
      end
    end
  end

  def destroy
    @online_mock_exam_attempt.destroy
    respond_to do |format|
      format.html { redirect_to online_mock_exam_attempt_temps_url, notice: 'Online exam attempt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def download
    olm = OnlineMockExamSection.find(params[:id])
    response.headers['Content-Type'] = 'application/pdf'
    uri = URI(olm.document.url)
    Net::HTTP.start(uri.host, uri.port, use_ssl: uri.scheme == 'https') do |http|
      request = Net::HTTP::Get.new uri
      http.request request do |res|
        res.read_body do |chunk|
          response.stream.write chunk
        end
      end
    end
    response.stream.close
  end

  private

  def set_online_mock_exam
    @online_mock_exam = OnlineMockExam.by_product_line("Gamsat").find_by(city: OnlineMockExam.cities[current_course.city], per_city_exam_count: 1, published: true)
  end

  def set_online_mock_exam_attempt
    @online_mock_exam_attempt = AssessmentAttempt.find(params[:id])
    authorize @online_mock_exam_attempt
  end

  def online_mock_exam_attempt_params
    params.require(:assessment_attempt).permit(:course_id, :assessable_id, :question_style, :timer_option_type, :attempt_mode, :section_one_score, :section_three_score, :section_type)
  end

  def set_sections
    @current_course = current_user.active_course
    if current_user.online_mock_exam_attempts.where(course_id: @current_course.id).present?
      @section_attempts = current_user.online_mock_exam_attempts.where(assessable_id: @online_mock_exam.id, course_id: @current_course.try(:id)).order(updated_at: :desc).first.try(:section_attempts) if @online_mock_exam.present?

      @section_attempts = @section_attempts.joins(:section).order('sections.position DESC') if @section_attempts.present?
      @attemptable = current_user.online_mock_exam_attempts.where(assessable_id: @online_mock_exam.id, course_id: @current_course.try(:id)).order(updated_at: :desc).first if @online_mock_exam.present?
      # @section_attempts = current_user.online_mock_exam_attempts.order(updated_at: :desc).first.section_attempts
      # @attemptable = current_user.online_mock_exam_attempts.find(current_user.online_mock_exam_attempts.order(updated_at: :desc).first)
    end
    @sections = current_course.product_version.type == 'GamsatReady' ?
    OnlineMockExam::GAMSAT_SECTION : current_course.product_version.type == 'UmatReady' ? OnlineMockExam::UMAT_SECTION : '' unless current_course.nil?
  end
end
