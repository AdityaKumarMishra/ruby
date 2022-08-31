class MockExamEssaysController < ApplicationController
  # layout 'layouts/dashboard'
  layout :resolve_layout
  before_action :authenticate_user!
  before_action :set_course, only: [:index, :create, :update]
  before_action :check_mock_essay, only: [:create, :update]
  before_action :find_mock_exam, only: [:feedbacks, :assign_tutor, :update_tutor, :update]

  def index
    mock_exam_essay = current_user.mock_exam_essays.find_by(course_id: @current_course)
    if mock_exam_essay.present? && MockExamEssay.statuses[mock_exam_essay.status] !=0
      @mock_exam_essay = mock_exam_essay
    else
      @mock_exam_essay = mock_exam_essay || MockExamEssay.new
      @mock_exam_essay.mock_essays.build
      @assigned_tutor = current_course.staff_profiles.present? ? current_course.staff_profiles.first.staff.id : User.find_by(email: "hr@gradready.com.au").id
    end
  end

  def create
    @mock_exam_essay = current_user.mock_exam_essays.new(exam_essay_params)
    respond_to do |format|
      if @mock_exam_essay.save
        exam = current_user.live_exams.find_by(course_id: @current_course)
        if exam.nil?
          live_exam = LiveExam.create(section_one_score: 0, section_two_score: 0, section_three_score: 0, course_id: @current_course.id, user_id: current_user.id, section_type: params[:mock_exam_essay][:section_type])
        else
          @mock_exam_essay.update(live_exam_id: exam.id)
        end
        MockExamEssayMailer.new_mock_essays(@mock_exam_essay).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
        notice = "Mock Exam Essays successfully submitted."
        flash[:notice] = notice
      else
        notice = "Please ensure that total file size do not exceed 4 MB i.e. 2 MB for each essay."
        flash[:error] = notice
      end
      format.html { redirect_to live_exams_path }
    end
  end

  def update
    respond_to do |format|
      if @mock_exam_essay.update(exam_essay_params)
        exam = current_user.live_exams.find_by(course_id: @current_course)
        if exam.nil?
          live_exam = LiveExam.create(section_one_score: 0, section_two_score: 0, section_three_score: 0, course_id: @current_course.id, user_id: current_user.id, section_type: params[:mock_exam_essay][:section_type])
        else
          @mock_exam_essay.update(live_exam_id: exam.id)
        end
        MockExamEssayMailer.new_mock_essays(@mock_exam_essay).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
        notice = "Mock Exam Essays successfully submitted."
        flash[:notice] = notice
      else
        notice = "Please ensure that total file size do not exceed 4 MB i.e. 2 MB for each essay."
        flash[:error] = notice
      end
      format.html { redirect_to live_exams_path }
    end
  end

  def feedbacks

  end

  def assign_tutor
    remove_ids = [current_user.id] + @mock_exam_essay.assigned_tutors
    @tutors = User.tutor.where.not(id: remove_ids).includes(:tutor_profile, :staff_profile).where("tutor_profiles.id IS NOT NULL AND staff_profiles.id IS NOT NULL").references(:tutor_profiles, :staff_profiles).sort { |a, b| a.full_name <=> b.full_name }
  end

  def update_tutor
    tutor = User.where(id: @mock_exam_essay.assigned_tutors).first
    @mock_exam_essay.assigned_tutors = [params[:tutor].to_i]
    if @mock_exam_essay.save
      confirm_tutors(@mock_exam_essay, tutor)
      redirect_to dashboard_mock_exam_essays_path, notice: 'Mock Exam Essay is successfully assigned.'
    else
      redirect_to dashboard_mock_exam_essays_path, error: 'Error is assigning Mock Exam Essay.'
    end
  end

  def mass_update_tutor
    if params[:assign_essays]['responses_ids'].present? && params[:tutor].present?
      tutor = User.find(params[:tutor])
      ids = if cookies["to_mark_mock_essay"] == "true"
              params[:total_response_ids].split(" ")
            else
              params[:assign_essays]['responses_ids']
            end
      mock_exam_essays = MockExamEssay.where(id: ids)
      mock_exam_essays.each do |mock_exam_essay|
        mock_exam_essay.assigned_tutors = [params[:tutor].to_i]
        mock_exam_essay.save
        confirm_tutors(mock_exam_essay, tutor)
      end
      redirect_to dashboard_mock_exam_essays_path, error: 'Mock Exam Essays is successfully assigend!'
    else
      redirect_to dashboard_mock_exam_essays_path, error: 'You have not selected either mock exam essays or tutor!'
    end
  end

  private

  def confirm_tutors(mock_exam_essay, tutor)
    MockExamEssayMailer.new_tutor_assigned(mock_exam_essay).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
    MockExamEssayMailer.inform_old_tutor(mock_exam_essay, tutor).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
  end

  def find_mock_exam
    @mock_exam_essay = MockExamEssay.find(params[:id])
  end

  def set_course
    @current_course = current_user.active_course
  end

  def check_mock_essay
    if !params[:mock_exam_essay][:mock_essays_attributes] || params[:mock_exam_essay][:mock_essays_attributes].count != 2
      error = 'Please Submit both Essays'
      redirect_to(mock_exam_essays_path, alert: error) and return
    end
  end

  def exam_essay_params
    params.require(:mock_exam_essay).permit(:course_id, :status, :submitted_at, :marked_at, assigned_tutors: [], mock_essays_attributes: [:id, :essay])
  end

  def resolve_layout
    (action_name == 'feedbacks') && current_user.student? ? 'student_page' : 'dashboard'
  end

end
