class LiveExamsController < ApplicationController
  # layout 'layouts/dashboard'
  layout :resolve_layout
  before_action :authenticate_user!
  before_action :set_course_and_sections, only: [:index, :create, :update]

  def index
    if @sections.present?
      master_feature = current_user.accessible_features.find_by('name LIKE?', '%LiveMockExamFeature%')
      @announcement = Announcement.find_by(master_feature_id: master_feature.try(:id), product_line_id: current_course.try(:product_version).try(:product_line_id))
      if @announcement.present?
        @user_announcement = current_user.user_announcements.find_by(announcement_id: @announcement.id)
        @user_announcement = current_user.user_announcements.create(announcement_id: @announcement.id, viewed: false) unless @user_announcement.present?
      end
      exam = current_user.live_exams.find_by(course_id: @current_course)
      exam.calculate_percentile if exam.present? && (exam.total_score > 0)
      @live_exam = exam.present? ? exam : LiveExam.new
      authorize(@live_exam)
      mock_exam_essay = current_user.mock_exam_essays.find_by(course_id: @current_course)
      if mock_exam_essay.present? && MockExamEssay.statuses[mock_exam_essay.status] !=0
        @mock_exam_essay = mock_exam_essay
      else
        @mock_exam_essay = mock_exam_essay || MockExamEssay.new
        @mock_exam_essay.mock_essays.build
        @assigned_tutor = current_course.staff_profiles.present? ? current_course.staff_profiles.first.staff.id : User.find_by(email: "hr@gradready.com.au").id
      end
    else
      redirect_to root_path, notice: 'This Feature is coming soon...'
    end
  end

  def create

    exam = current_user.live_exams.find_by(course_id: @current_course)
    if exam.nil?
      @live_exam = current_user.live_exams.new(live_exam_params)
      authorize(@live_exam)

      if @live_exam.save
        @live_exam.calculate_percentile
        redirect_to live_exams_path, notice: 'Score is successfully submitted.'
      else
        @mock_exam_essay = MockExamEssay.new
        render 'index'
      end
    else
      if params[:live_exam][:section_three_score].present?
        @live_exam = exam.update_attribute(:section_three_score, params[:live_exam][:section_three_score])
      elsif params[:live_exam][:section_one_score].present?
        @live_exam = exam.update_attribute(:section_one_score, params[:live_exam][:section_one_score])
      elsif params[:live_exam][:section_two_score].present?
        @live_exam = exam.update_attribute(:section_two_score, params[:live_exam][:section_two_score])
      end
      redirect_to live_exams_path, notice: 'Score is successfully submitted.'
    end
  end

  def update
    if params[:live_exam][:section_three_score].present?
      @live_exam = LiveExam.find(params[:id]).update_attribute(:section_three_score, params[:live_exam][:section_three_score])
    end
    if params[:live_exam][:section_one_score].present?
      @live_exam = LiveExam.find(params[:id]).update_attribute(:section_one_score, params[:live_exam][:section_one_score])
    end
    if params[:live_exam][:section_two_score].present?
      @live_exam = LiveExam.find(params[:id]).update_attribute(:section_two_score, params[:live_exam][:section_two_score])
    end
    @live_exam = LiveExam.find(params[:id])
    total_score = @live_exam.section_one_score + @live_exam.section_two_score + @live_exam.section_three_score
    @live_exam = @live_exam.update_attribute(:total_score, total_score)
    redirect_to live_exams_path, notice: 'Score is successfully submitted.'
  end

  def destroy
    @live_exam = LiveExam.find(params[:id])
    authorize(@live_exam)
    if @live_exam.destroy
      notice = 'Score is deleted successfully.'
    else
      notice = 'Score is deleted successfully.'
    end
    redirect_back fallback_location: root_path, notice: notice
  end

  private
  def set_course_and_sections
    @current_course = current_user.active_course
    @sections = @current_course.product_version.type == 'GamsatReady' ?
                LiveExam::GAMSAT_SECTION : @current_course.product_version.type == 'UmatReady' ? LiveExam::UMAT_SECTION : '' unless @current_course.nil?
  end

  def live_exam_params
    params.require(:live_exam).permit(:section_one_score, :section_two_score, :section_three_score, :course_id, :section_type)
  end

  def resolve_layout
    (action_name == 'index') && current_user.student? ? 'student_page' : 'dashboard'
  end

end
