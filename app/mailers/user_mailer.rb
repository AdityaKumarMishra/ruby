class UserMailer < ApplicationMailer
  def send_first_welcome_email(user)
    @user = user
    mail(to: check_environment ? DEFAULT_TO : @user.email, subject: "Welcome to GradReady!")
  end

  def feature_auto_email(user)
    # @student = user
    # mail(to: check_environment ? DEFAULT_TO : [@student.email, "rordev@ongraph.com"], subject: "Features that set GradReady apart from the crowd")
  end
end
