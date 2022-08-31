class Users::InvitationsController < Devise::InvitationsController
  before_action :configure_permitted_parameters

  def edit
    Address.new(addresable: resource).save(validate: false) if resource.address.nil?
    resource.reload
    super
  end

  def update
    super
  end

  def create
    user = User.find_by(email: params[:user][:email])
    if user.present?
      flash[:error] = "User already exist! email: #{user.email} with role: #{user.role}"
      redirect_back fallback_location: root_path
    else
      super
    end
  end

  private
  def after_invite_path_for(resource)
    user_emails_path
  end
end
