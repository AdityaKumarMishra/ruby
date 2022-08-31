require 'application_responder'
class ApplicationController < ActionController::Base
  before_action :prepare_exception_notifier
  before_action :configure_permitted_parameters, if: :devise_controller?
  include CanCan::ControllerAdditions
  include Pundit
  before_action :detect_device_variant
  rescue_from Pundit::NotAuthorizedError, with: :user_not_authorized
  self.responder = ApplicationResponder
  respond_to :html
  after_action :course_location
  protect_from_forgery with: :null_session, prepend: true
  helper_method :current_course
  before_action :set_service

  if Rails.env == 'stage'
    http_basic_authenticate_with name: "gradready", password: "grad2012ready"
  end

  def not_authorised_user
    redirect_to root_path, alert: 'You are not a teacher.'
  end

  def check_for_student
    redirect_to dashboard_courses_path unless current_user.student?
  end

  def after_invite_path_for(resources)
    user_emails_path
  end

  def get_announcement(name)
    announcement = @application_service.get_announcement_object(name)
    if !announcement.nil?
     return announcement
    end
  end

  def get_announcement_url(name)
    announcement = @application_service.get_announcement_object(name)
    if !announcement.nil?
     return announcement.url
    end
  end

  def get_dashboard_announcement
    announcement =  @application_service.get_announcement_for_dashboard
    unless announcement.nil?
      return announcement
    end
  end

  protected

  def authenticate_inviter!
    if !current_user.invite?(current_user,params[:user][:role])
      flash[:alert] = "You don't have sufficient permissions to perform that action"
      redirect_to user_emails_path and return
    end
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:first_name, :last_name, :username, :phone_number, :email, :password, :password_confirmation, :name, :provider, :uid, address_attributes: [:line_one, :line_two, :suburb, :post_code,:state, :country], questionnaire_attributes: [:university_id, :degree_id, :year,:umat_high_school, :umat_uni,:last_source, source: []]])
    devise_parameter_sanitizer.permit(:accept_invitation, keys: [:first_name, :last_name, :username, :email, :password, :phone_number,:password_confirmation, :invitation_token,address_attributes: [:line_one, :line_two, :suburb, :post_code, :state, :country]])
    devise_parameter_sanitizer.permit(:invite, keys: [:role, :email])
  end

  def course_location
    return unless request.get?
    if (request.path != "/users/sign_in" &&
        request.path != "/users/sign_up" &&
        request.path != "/users/password/new" &&
        request.path != "/users/password/edit" &&
        request.path != "/users/confirmation" &&
        request.path != "/users/sign_out" &&
        !request.xhr?) # don't store ajax calls
    end
  end

  def after_sign_in_path_for(resource)
    if current_user.session_url?
      session_url = current_user.session_url
      current_user.update(session_url: nil)
      session_url
    elsif current_user.student? && current_user.payment_flow_step.present? && (current_user.orders.where(status: :ongoing).present? && current_user.orders.where(status: :ongoing).last.purchase_items.present?) && AdminControl.find_by(name: 'Signup view').try(:new_view)
      current_user.payment_flow_step
    elsif current_user.student? && !current_user.paid_courses.present? && current_user.confirmed? && current_user.orders.where(status: :ongoing).first&.purchase_items.present? && AdminControl.find_by(name: 'Signup view').try(:new_view) && !current_user.address.present?
      update_contact_user_path(current_user)
    else
      session[:previous_url] = nil if session[:previous_url].present? && session[:previous_url].include?('trial_enabled.json')
      if current_user.student?
        session[:previous_url] || dashboard_home_path
      else
        dashboard_home_path
      end
    end
  end

  def after_sign_up_path_for(resource)
    session[:previous_url]
  end

  NO_ACCESS_ALERT = 'Oops! There seems to be something wrong. Please send through an issue ticket using the button below.'
  NO_LOGIN_ALERT = 'Please login to your account.'

  protected
  def authenticate_user!(force=false)
    if user_signed_in?
      cookies.delete :anonymous_user_id
      Raven.user_context(
        id: current_user.id,
        email: current_user.email
      )
      active_course_ids = current_user.active_enrolled_courses.ids
      if active_course_ids.exclude?(current_user.active_course_id.to_i)
        current_user.update_attribute(:active_course_id, current_user.active_enrolled_courses.ids.first)
      end
      session[:previous_url] || root_path
    else
      cookies[:anonymous_user_id] ||= SecureRandom.hex
      Raven.user_context({anonymous_id: cookies[:anonymous_user_id]})
      session[:previous_url] = request.fullpath
      if !(session[:previous_url].include?('enrolments/enrol'))
        flash[:alert] = NO_LOGIN_ALERT
      end
      if (controller_name == "textbooks" && action_name == "timetable")
        redirect_to new_user_session_path
      else
        redirect_to new_user_registration_path
      end
    end
  end

  private
  def user_not_authorized
    flash[:alert] = NO_ACCESS_ALERT
    return_url = request.referrer || root_path
    if params[:controller] == "issue_forum" && params[:action] == "show"
      unless current_user
        session[:previous_url] = request.url
        return_url = new_user_session_path
        flash[:alert] = NO_LOGIN_ALERT
      else
        return_url = root_path
      end
    end
    redirect_to(return_url)
  end

  def redirect_back_with_fallback(url, options = {})
    if request.env["HTTP_REFERER"].present? && request.env["HTTP_REFERER"] != request.env["REQUEST_URI"]
      redirect_back(fallback_location: root_path,options: options)
    else
      redirect_to url, options
    end
  end

  def current_course
    return nil unless current_user
    current_user.active_course
  end

  def choose_course
    return nil unless current_user
    if current_user.student?
      @courses = current_user.active_enrolled_courses
      if current_course.present?
        current_user.active_course = current_course
      else
        current_user.active_course = @courses.first
      end
    end
  end

  def transform_courses(courses)
    new_courses = []

    courses.select { |c| c.enrolment_end_date >= Time.zone.now.beginning_of_day }.each { |c| new_courses << c }
    courses.select { |c| c.enrolment_end_date < Time.zone.now.beginning_of_day }.each { |c| new_courses << c }

    new_courses
  end

  def after_sign_out_path_for(resource)
    session[:signed_out] = true
    super
  end

  def detect_device_variant
    request.variant = :phone if browser.device.mobile?
  end

  def prepare_exception_notifier
    Rails.logger.info "=============================================="
    Rails.logger.info request.ip
    Rails.logger.info request.user_agent
    Rails.logger.info "=============================================="
    request.env["exception_notifier.exception_data"] = {
      current_user: current_user
    }
  end

  def set_custom_course_purchase_addons_for_free_trail
    @user_custom_course = @application_service.set_custom_course(current_course)
  end

  def set_service
    @application_service = ApplicationService.new(current_user)
  end
end
