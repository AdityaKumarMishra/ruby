class BlogPostMailer < ApplicationMailer
  layout 'post_mailer'
  #default from: "contact@gradready.com.au"
  default from: "student.care@gradready.com.au"

  def new_post_notification(post, email, first_name, last_name)
    # @post = post
    # @first_name = first_name
    # @last_name = last_name
    # @email = email

    # mail(to: check_environment ? DEFAULT_TO : email, subject: "#{@post.name} - posted on GradReady")
  end

  def blog_mail_to_student(post, user)
    @user = user
    @post = post
    @email = user.email
    @name = user.try(:full_name)
    mail(to: check_environment ? DEFAULT_TO : [@email], subject: "#{@post.name} - posted on GradReady")
  end

  def welcome_subscription type, email
    @blog_type = type
    mail(to: check_environment ? DEFAULT_TO : email, subject: "Blog Subscription Email")
  end

end
