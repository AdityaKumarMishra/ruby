class UsersController < ApplicationController
  include UsersHelper
  layout :resolve_layout
  before_action :authenticate_user!, except: [:search, :check_email, :study_guide, :free_gamsat_trial, :destroy_ongoing_orders]
  before_action :set_user, only: [:edit, :update, :destroy, :deactivate, :resend_invitation, :transfer_data, :transfer], except: [:search]
  respond_to :html, :js
  before_action :find_user, only: [:update_contact, :save_detail, :course_details]

  # Sign up new user
  def new
    redirect_to dashboard_home_url and return if current_user.student?

    @user = User.new(role: nil)
    @user.build_questionnaire(student_level: nil)
    @user.build_address
    @user.build_tutor_profile
    @user.build_staff_profile
    authorize @user
    respond_with(@user)
  end

  # Edit user
  def edit
    @view_type = AdminControl.find_by(name: 'Signup view')
    @user.validate_staff_profile
    @user.validate_tutor_profile
    @user.validate_user_address
  end

  # Create new user from new form information
  def create
    @user = Users::NewRecord.call(params, user_params)
    authorize @user
    respond_to do |format|
      if @user.save
        format.html { redirect_to user_emails_path, notice: 'User successfully created' }
        format.json { render :show, status: :created, location: @user }

      else
        format.html { render :new }
        format.json { render json: @user.errors, status: :unprocessable_entity }
      end
    end

  end

  # Update user from edit form information
  def update
    redirect_to dashboard_home_url and return if current_user.student?
    @user = Users::UpdateRecord.call(params, user_params, @user)
    respond_with(@user, location: edit_user_path)
  end

  # Deleting a user
  def destroy
    msg = @user.destroy ? 'User deleted successfully!' : 'Problem in deleting user please try concerned person!'
    redirect_to user_emails_path, notice: msg
  end

  # Remove all user onging orders
  def destroy_ongoing_orders
    Users::DestroyOngoingOrders.call(current_user)
    head :ok
  end

  # Deactivate user
  def deactivate
    authorize current_user
    @user.update_attribute(:status, User.statuses[params[:status]])
    redirect_to user_emails_path, notice: 'User successfully deactivated!'
  end

  # Reset a user's password via email
  def generate_new_password_email
    @user = User.friendly.find(params[:user_id])
    authorize @user
    @user.send_reset_password_instructions
    flash[:notice] = "Reset password instructions have been sent to #{@user.email}."
    redirect_to user_emails_path and return
  end

  # sign in as a specific user (only available for manager and admin users)
  def become
    authorize current_user
    sign_out current_user
    sign_in(:user, User.friendly.find(params[:user_id]))
    redirect_to root_url, notice: "You are now signed in as #{current_user.full_name}"
  end

  # check if email is already occupied for user sign up 
  def check_email
    if params[:user].present?
      @user = User.find_by_email(params[:user][:email])
      respond_to do |format|
        format.json {render :json => !@user}
        format.html{render :nothing=> true}
      end
    else
      render 'errors/not_found'
    end
  end

  # Destroy multiple users
  def destroy_all
    users = User.where(id: params[:user_ids].split(' '))
    msg = users.destroy_all ? "Users deleted successfully!!" : "Error in deleting users, please contact concerned person!"
    redirect_to user_emails_path, notice: msg
  end

  # Verify users page
  def verify_users
    @users  = User.where(id: params[:user_ids])
  end

  # Tutor interaction logs page
  def tutor_interaction_logs
    @user  = User.friendly.find(params[:id])
  end

  def transfer_data
    staff_profile = @user.staff_profile
    tutor_responses = EssayResponse.where(tutor_id: @user.id)
    tutor_essays = Essay.where(tutor_id: @user.id)
    @no_essay = false
    @no_essay = true unless staff_profile.present? && (staff_profile.essay_tutor_responses.present? || staff_profile.course_staffs.present? || tutor_responses.present? || tutor_essays.present?)
    @staffs = User.where.not(id: @user.id, role: User.roles['student']).includes(:tutor_profile, :staff_profile).where("tutor_profiles.id IS NOT NULL AND staff_profiles.id IS NOT NULL").references(:tutor_profiles, :staff_profiles).sort { |a, b| a.full_name <=> b.full_name }
  end

  def transfer
    @user, @staff = Users::Transfer.call(params, @user)
    redirect_to transfer_data_user_path(@user)
  end

  # Resend user confirmation instruction
  def resend_invitation
    if @user.confirmed_at.nil?
      @user.send_confirmation_instructions
      msg = 'Invitation has been resent successfully!'
    else
      msg = 'User already accepted invitation!'
    end
    redirect_to user_emails_path, notice: msg
  end

  # reset user exams page
  def reset_exams
    @student = User.find(params[:id])
    @mcqs = @student.exercises
    @diagnostics = @student.assessment_attempts.where(assessable_type: "DiagnosticTest")
    @exams = @student.assessment_attempts.where(assessable_type: "OnlineExam")
    @essay = @student.essay_responses.joins(:essay).sort{|a, b| b.title.gsub("Essay ","").to_i <=> a.title.gsub("Essay ","").to_i }
    @not_submit_essay = @student.essay_responses.where('time_submited IS NULL AND status = 0 AND expiry_date >= ?',Time.zone.now.in_time_zone("Australia/Queensland"))
    @submit_essay = @student.essay_responses.where('time_submited IS NOT NULL AND status = 1')
    @expired_essay = @student.essay_responses.where('time_submited IS NULL AND status = 0 AND expiry_date < ?',Time.zone.now.in_time_zone("Australia/Queensland"))
    @marked_essay = @student.essay_responses.where('status = 2 OR status = 3 AND time_submited IS NOT NULL')
    @appointment = @student.appointments.active
    @online_mock_exam_attempt = @student.online_mock_exam_attempts
  end

  # reset user online exam
  def reset_ol_exam
    msg = Users::ResetOnlineExam.call(params)
    render js: "document.location = '#{edit_user_enrolment_path(params[:user_id], params[:enrolment_id])}'"
    flash[:notice] = msg
  end

  # reset user online mock exam attempt
  def reset_online_mock_exam_attempt
    msg = Users::ResetOnlineMockExamAttempt.call(params)
    render js: "document.location = '#{reset_exams_user_path(params[:user_id])}'"
    flash[:notice] = msg
  end

  # reset user diagnostic
  def reset_diganostic
    msg = Users::ResetDiagnostic.call(params)
    render js: "document.location = '#{reset_exams_user_path(params[:user_id])}'"
    flash[:notice] = msg
  end

  # cancel user appointment
  def cancel_appointment
    msg = Users::CancelAppointment.call(params, current_user)
    render js: "document.location = '#{reset_exams_user_path(params[:user_id])}'"
    flash[:notice] = msg
  end

  # reset user essay
  def reset_essay
    msg = Users::ResetEssay.call(params)
    render js: "document.location = '#{edit_user_enrolment_path(params[:user_id], params[:enrolment_id])}'"
    flash[:notice] = msg
  end

  # reset user mock exam
  def reset_mock_exam
    msg = Users::ResetMockExam.call(params)
    render js: "document.location = '#{reset_exams_user_path(params[:user_id])}'"
    flash[:notice] = msg
  end

  # update contact page during sign up
  def update_contact
    @user.update_attribute(:payment_flow_step , request.path) if AdminControl.find_by(name: 'Signup view').try(:new_view)
    @enrolment_items = current_course.present? ? @user.enrolments.where(course_id: current_course.id) : @user.validate_order.purchase_items.where(purchasable_type: 'Enrolment')
    @user.build_address(state: nil, country: nil) if @user.address.blank?
    render layout: 'layouts/student_page'
  end

  # save detail page during sign up
  def save_detail
    if @user.update(user_params)
      path = Users::SaveDetail.call(@user, user_params, current_course, self, params)
      redirect_to path
    else
      if user_params[:questionnaire_attributes].present?
        @update_background = true
        @questionnaire = @user.questionnaire
        render 'dashboard/home', layout: 'layouts/student_page'
      else
        render :update_contact, layout: 'layouts/student_page'
      end
    end
  end

  # course details page during sign up
  def course_details
    @outofstock, @order, @user, @enrolment_items, @notification, @enrolment, @course = Users::FetchCourseDetails.call(@user, request.path)
    redirect_to order_path(@order, payment_page: true, allow_purchase: true) and return if @enrolment.nil?

    @show_lesson, @enrolment, @custom_mock, @course, @order, @cities, @courses = Users::UpdateCourseOrderDetail.call(params, @course, current_user, @enrolment, @order)
    if @course.present?
      render layout: 'layouts/student_page'
    else
      redirect_to dashboard_home_path
    end
  end

  # action to enrol into study guide
  def study_guide
    flash[:error], @user, @course, path = Users::StudyGuide.call(params, user_params, @user, self)
    redirect_to path
  end

  # action to enrol into free gamsat trial
  def free_gamsat_trial
    Rails.logger.info "=============================================="
    Rails.logger.info request.ip
    Rails.logger.info request.user_agent
    Rails.logger.info "=============================================="

    if session[:ip].blank? && session[:registration_count].blank?
      session[:ip] = request.remote_ip
      session[:registration_count] = 1
    end

    seconds_difference = (BigDecimal(params[:user][:signup_form_end_time].presence || 0) / 1000) - (BigDecimal(params[:user][:signup_form_start_time].presence || 0)/ 1000)
    if params['g-recaptcha-response'].nil? || params['g-recaptcha-response'] == "" || (seconds_difference < 2) || session[:registration_count] > 2 || (user_params[:email].present? && user_params[:email].include?('gmail.com') && user_params[:email].split(/\s*@\s*/).first.count('.') >= 4)
      redirect_to root_path, alert: 'Unable to create user, please try again later'
    else
      @course, @user, error, notice, path = Users::FreeGamsatTrial.call(params, user_params, session, self)
      flash[:error] = error if error.present?
      flash[:notice] = notice if notice.present?
      redirect_to path
    end
  end

  def display_expiry_date
    @expiry_date = EssayResponse.find(params[:essay_id]).expiry_date if params[:essay_id].present?
  end

  private

  def user_params
    params.require(:user).permit(:first_name, :last_name, :date_of_birth, :username, :email, :phone_number,
                                 :bio, :password, :role, :area,:photo, :remove_photo, :redirect_sign_up,
                                 :email_subscription, :private_tutor_subscribe_email,
                                 address_attributes: [:id, :_destroy, :line_one, :line_two, :suburb, :post_code, :state, :country, :city],
                                 questionnaire_attributes:[:id, :_destroy, :student_level, :year, :umat_high_school,
                                                           :umat_uni, :last_source, :university_id, :degree_id, :current_highschool,
                                                           :target_uni_course, :highschool_year_level, :language_spoken,
                                                           :student_region, :designation, :learning_institution,
                                                           :year_of_most_recent_completed_qualification, source: []],
                                 tutor_profile_attributes: [ :id, :_destroy, :tutor_id, :private_tutor, :issue_ticket],
                                 staff_profile_attributes: [ :id, :_destroy, :staff_id, tag_ids: [],
                                 tags_attributes: [ :id, :name, :description, :parent_id, :_destroy ]],
                                 verseeing_tag_ids: [])
  end
end
