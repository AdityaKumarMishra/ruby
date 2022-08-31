class Users::RegistrationsController < Devise::RegistrationsController
  before_action :configure_permitted_parameters
  invisible_captcha only: [:create], honeypot: :subtitle
  layout :determine_layout

  def new
    Rails.logger.info "=============================================="
    Rails.logger.info request.ip
    Rails.logger.info "=============================================="
    admin_ip = ['101.167.31.206', '203.121.201.183']
    if session[:previous_url].present? && session[:previous_url].include?('/enrolments/enrol')
      course_id = session[:previous_url].gsub(/[^0-9]/, '')
      @course = Course.find_by(id: course_id)
      @trail_course = true if @course.present? && ProductVersion.course_types[@course.product_version.course_type] == 0
      @free_study_guide = true if @course.present? && ProductVersion.course_types[@course.product_version.course_type] == 10
    end
    if @trail_course
      product_request = SystemInfo.find_by(ip: request.ip, product_line: @course.product_version.type)
      user_request = SystemInfo.find_by(ip: request.ip, user_agent: request.user_agent, product_line: @course.product_version.type)
      if product_request || user_request
        if (product_request.present? && admin_ip.include?(product_request.ip)) || (user_request.present? && admin_ip.include?(user_request.ip))
          super
        else
          flash[:error] = 'User had registered earlier'
          redirect_back fallback_location: root_path
        end
      else
        super
      end
    else
      super
    end
  end

  def create
    Rails.logger.info "=============================================="
    Rails.logger.info request.ip
    Rails.logger.info "=============================================="
    if params['g-recaptcha-response'].nil? || params['g-recaptcha-response'] == ""
      redirect_to root_path
    else
      admin_ip = ['101.167.31.206', '203.121.201.183']

      course_id = session[:previous_url].gsub(/[^0-9]/, '') if session[:previous_url].present?
      @course = Course.find_by(id: course_id)

      params[:user][:questionnaire_attributes][:language_spoken] = params[:language_spoken] if  params[:language_spoken].present? && params[:user][:questionnaire_attributes][:language_spoken]=="other"
      params[:user][:questionnaire_attributes][:last_source] = params[:last_source] if  params[:last_source].present? && params[:user][:questionnaire_attributes][:last_source]=="other"

      params[:user][:questionnaire_attributes][:source]<<params[:source] if params[:source].present?

      high_school_string = params["user"].try(:[], "questionnaire_attributes").try(:[], "currcurrent_highschool")
      high_school = HighSchool.find_by_name(high_school_string)
      if high_school.nil? && high_school_string
        HighSchool.create(name: high_school_string)
      end
      if session[:previous_url].present? && session[:previous_url].include?('/enrolments/enrol')
        course_id = session[:previous_url].gsub(/[^0-9]/, '')
        course = Course.find_by(id: course_id)
        @trail_course = true if course.present? && course.product_version.slug.include?('trial')
      end
      if @trail_course
        product_request = SystemInfo.find_by(ip: request.ip, product_line: course.product_version.type)
        user_request = SystemInfo.find_by(ip: request.ip, user_agent: request.user_agent, product_line: course.product_version.type)
        if product_request || user_request
          if course.product_version.type == "GamsatReady"
            take_path = "/gamsat-preparation-courses/free-trial"
          else
            take_path = "/umat-preparation-courses/free-trial"
          end
          if (product_request.present? && admin_ip.include?(product_request.ip)) || (user_request.present? && admin_ip.include?(user_request.ip))
            super
          else
            flash[:error] = 'User had registered earlier'
            redirect_to take_path
          end
        else
          begin
          ActiveRecord::Base.transaction do
            super
          end
          rescue ActiveRecord::RecordInvalid => exception
            redirect_to(:back, error: 'Action denied, create user after sometime')
          end
        end
      else
        begin
        ActiveRecord::Base.transaction do
           super
        end
        rescue ActiveRecord::RecordInvalid => exception
          redirect_to(:back, error: 'Action denied, create user after sometime')
        end
      end
    end
  end

 def edit
    @view_type = AdminControl.find_by(name: 'Signup view')
    resource.validate_user_address
    super
  end

  def update
    params[:user][:questionnaire_attributes][:language_spoken] = params[:language_spoken] if  params[:language_spoken].present? && params[:user][:questionnaire_attributes][:language_spoken]=="other"

    params[:user][:questionnaire_attributes][:last_source] = params[:last_source] if  params[:last_source].present? && params[:user][:questionnaire_attributes][:last_source]=="other"

    params[:user][:questionnaire_attributes][:source]<<params[:source] if params[:source].present?
    super
  end

  def destroy
    super
  end

  # GET /resource/cancel
  # Forces the session data which is usually expired after sign
  # in to be expired now. This is useful if the user wants to
  # cancel oauth signing in/up in the middle of the process,
  # removing all OAuth session data.
  # def cancel
  #   super
  # end

  def determine_layout
    if (current_user.present? && current_user.student?) || (session[:previous_url].present? && (session[:previous_url].include?('/enrolments/enrol') || session[:previous_url].include?('/enrolments/custom_enrol'))) || action_name == "new"
      'student_page'
    else
      'dashboard'
    end
  end

  protected

  def configure_permitted_parameters
      devise_parameter_sanitizer.permit(:sign_up, keys: [:phone_number,:date_of_birth,:username, :first_name, :last_name,:email,:password,:password_confirmation, :provider, :uid, :session_url,
                 address_attributes: [:line_one,:line_two,:suburb,:post_code,:state,:country],
                 questionnaire_attributes: [:year,:umat_high_school,:umat_uni, :last_source ,:university_id,:degree_id,
                                            :student_level, :highschool_year_level, :current_highschool, :target_uni_course, :language_spoken, :student_region, :designation, :learning_institution,
                                              :year_of_most_recent_completed_qualification,
                                              source: []],
                 tutor_profile_attributes: [ :id, :_destroy, :tutor_id, :private_tutor, tag_ids: [], excluded_tag_ids: [],
                                             tags_attributes: [ :id, :name, :description, :parent_id, :_destroy ]]])
      devise_parameter_sanitizer.permit(:account_update, keys: [:name,
                 :email, :password, :password_confirmation, :current_password, :photo, :remove_photo, :phone_number, :first_name, :last_name,
                address_attributes: [
                  :id,
                  :line_one,
                  :line_two,
                  :suburb,
                  :post_code,
                  :state,
                  :country,
                  :_destroy
                ],
                questionnaire_attributes: [
                  :id,
                  :_destroy,
                  :year,
                  :umat_high_school,
                  :umat_uni,
                  :last_source,
                  :university_id,
                  :degree_id,
                  :student_level,
                  :highschool_year_level,
                  :current_highschool,
                  :target_uni_course,
                  :language_spoken,
                  :student_region,
                  :designation,
                  :learning_institution,
                  :year_of_most_recent_completed_qualification,
                  source: []
                ]])
    end


  def sign_up_params
    UserService.new.params(devise_parameter_sanitizer.sanitize(:sign_up))
  end


  # The path used after sign up.
  def after_sign_up_path_for(resource)
    super(resource)
  end

  def after_update_path_for(resource)
    edit_user_registration_path
  end

  # The path used after sign up for inactive accounts.
  def after_inactive_sign_up_path_for(resource)
    view_type = AdminControl.find_by(name: 'Signup view')
    if view_type.present? && view_type.new_view
      new_user_registration_path
    else
      sign_in_path
    end
  end
end
