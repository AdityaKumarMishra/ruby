class Users::ConfirmationsController < Devise::ConfirmationsController
  layout 'layouts/student_page'
  # GET /resource/confirmation/new
  # def new
  #   super
  # end

  # POST /resource/confirmation
  def create
    if params[:user][:email].blank?
      flash[:error] = 'Invalid email'
      redirect_to sign_in_path
    elsif !User.find_by(email: params[:user][:email]).present?
      flash[:error] = 'Invalid email'
      redirect_to sign_in_path
    else
      super
    end
  end

  # GET /resource/confirmation?confirmation_token=abcdef
  # def show
  #   super
  # end

  # protected

  # The path used after resending confirmation instructions.
  # def after_resending_confirmation_instructions_path_for(resource_name)
  #   super(resource_name)
  # end

  # The path used after confirmation.
  # def after_confirmation_path_for(resource_name, resource)
  #   super(resource_name, resource)
  # end

  private
  def after_confirmation_path_for(resource_name, resource)
    sign_in(resource)
    resource.send_emails_after_confirmation
    if resource.session_url?
      session_url = resource.session_url
      resource.update(session_url: nil)
      session_url
    else
      session[:previous_url] = nil if session[:previous_url].present? && session[:previous_url].include?('trial_enabled.json')
      resource.fetch_thankyou_path
    end
  end
end
