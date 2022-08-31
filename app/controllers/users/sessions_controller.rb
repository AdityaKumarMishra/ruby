class Users::SessionsController < Devise::SessionsController
  # before_filter :configure_sign_in_params, only: [:create]
  before_action :add_total_time_spend!, :only => :destroy

  layout 'layouts/public_page', only: [:new]

  def new
    @user = User.new(role: :student)
    super
  end

  def is_signed_in
    if user_signed_in?
      render json: { signed_in: true, user: current_user }
    else
      render json: { signed_in: false }
    end
  end

  def destroy
    session[:course_id] = nil
    # if session[:section_attempt].present?
    #   section_attempt = SectionAttempt.find(session[:section_attempt])
    #   section_attempt.completed!
    #   session[:section_attempt] = nil
    # end

    # if session[:exercise_attempt].present?
    #   exercise = Exercise.find(session[:exercise_attempt])
    #   exercise.finish!
    #   session[:exercise_attempt] = nil
    # end
    # cookies[:current_sa] = nil
    # cookies[:current_exe_atmpt] = nil
    super
  end


  protected

  # You can put the params you want to permit in the empty array.
  # def configure_sign_in_params
  #   devise_parameter_sanitizer.for(:sign_in) << :attribute
  # end

  def add_total_time_spend!
    if current_user.present?
      logged_in = current_user.current_sign_in_at
      logged_out = Time.zone.now
      total_time = ((logged_out - logged_in) / 60).round
      current_user.update_attribute('total_online_time', current_user.total_online_time + total_time)
    end
  end
end
