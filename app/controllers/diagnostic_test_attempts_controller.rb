class DiagnosticTestAttemptsController < ApplicationController
  layout 'layouts/mathjax'
  layout 'layouts/student_page'
  before_action :authenticate_user!
  before_action :set_diagnostic_test_attempt, only: [:show, :edit, :update, :destroy]
  def index
    master_feature = current_user.accessible_features.find_by('name LIKE?', '%Diagnostic%')
    @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
    if @announcement.present?
      @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
      @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
    end
    course_tag_ids = current_user.current_course_tags.map(&:id)
    @diagnostic_test_attempts = policy_scope(AssessmentAttempt).where(assessable_type: 'DiagnosticTest').includes(diagnostic_test: :tags).where(tags: { id: course_tag_ids })
    user_attempt_ids = @diagnostic_test_attempts.pluck(:assessable_id)
    @diagnostic_tests = policy_scope(DiagnosticTest).select{|test|  !user_attempt_ids.include? test.id}.sort_by(&:title)
    authorize(@diagnostic_test_attempts, :diagnostic_test_index?)
    @diagnostic_test_attempt = current_user.diagnostic_test_attempts.new
  end

  def show
    if @diagnostic_test_attempt.course_id != current_course.try(:id)
      redirect_to diagnostic_test_attempts_path
    end
  end

  def new
    @course = current_course
    @diagnostic_test_attempt = current_user.diagnostic_test_attempts.new
  end

  def create
    @course = current_course
    cookies.delete :current_sa if !cookies[:current_sa].nil?
    cookies.delete :current_exe_atmpt if !cookies[:current_exe_atmpt].nil?
    @diagnostic_test_attempt = current_user.diagnostic_test_attempts.new(diagnostic_test_attempt_params)
    authorize @diagnostic_test_attempt if @diagnostic_test_attempt.valid?
    respond_to do |format|
      if @diagnostic_test_attempt.save
        format.html { redirect_to diagnostic_test_attempt_path(@diagnostic_test_attempt), notice: 'Diagnostic test attempt was successfully created.' }
        format.json { render :show, status: :created, location: @diagnostic_test_attempt }
      else
        format.html { render :new }
        format.json { render json: @diagnostic_test_attempt.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def destroy
    @diagnostic_test_attempt.destroy
    respond_to do |format|
      format.html { redirect_to diagnostic_test_attempts_url, notice: 'Diagnostic test attempt was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_diagnostic_test_attempt
    @diagnostic_test_attempt = AssessmentAttempt.find(params[:id])
    authorize @diagnostic_test_attempt
  end

  def diagnostic_test_attempt_params
    params.require(:assessment_attempt).permit(:course_id, :assessable_id, :question_style, :timer_option_type)
  end
end
