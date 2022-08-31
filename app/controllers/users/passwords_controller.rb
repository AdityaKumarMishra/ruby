class Users::PasswordsController < Devise::PasswordsController
  layout 'layouts/student_page'
  # GET /resource/password/new
  # def new
  #   super
  # end

  # POST /resource/password
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

  # GET /resource/password/edit?reset_password_token=abcdef
  # def edit
  #   super
  # end

  # PUT /resource/password
  # def update
  #   super
  # end

  # protected

  # def after_resetting_password_path_for(resource)
  #   super(resource)
  # end

  # The path used after sending reset password instructions
  # def after_sending_reset_password_instructions_path_for(resource_name)
  #   super(resource_name)
  # end
end
