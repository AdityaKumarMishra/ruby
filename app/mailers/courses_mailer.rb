class CoursesMailer < ApplicationMailer
  layout 'mailer'
  default from: "student.care@gradready.com.au"

  def course_full_notification(course)
    @course = course

    mail( to: check_environment ? DEFAULT_TO : "payment@gradready.com.au", subject: 'Course full notification')
  end

  def course_full_alert(course)
    @course = course
    mail(
      to: check_environment ? DEFAULT_TO : ['payment@gradready.com.au','michael.qiu@gradready.com.au'],
      subject: "Course is about to full"
    )
  end

  def expiry_notification_before_7_days(course, user)
    @course = course
    @user = user
    @student_name = @user.first_name
    @student_email = @user.email
    @title = @course.name
    @product_line = @course.product_version.type.split("Ready").first.upcase
    @expiry = @course.expiry_date
    @expiry_date = @expiry.strftime('%d %b %Y').to_s
    mail(
      to: check_environment ? DEFAULT_TO : [@student_email, "akhtar.ali@ongraph.com"],
      subject: "#{@title} is going to expire in 7 days"
    )
  end

  def expiry_notification(course, user)
    @course = course
    @user = user
    @student_name = @user.first_name
    @student_email = @user.email
    @product_line = @course.product_version.type.split("Ready").first.upcase
    @title = @course.name
    @expiry = @course.expiry_date
    @expiry_date = @expiry.strftime('%d %b %Y').to_s
    mail(
      to: check_environment ? DEFAULT_TO : @student_email,
      subject: "#{@title} is going to expire today"
    )
  end

  def create_time_timetable_mail(course, user)
    # @course = course
    # @title = @course.name
    # @user = user

    # @student_name = @user.first_name
    # @student_email = @user.email
    # mail(
    #   to: check_environment ? DEFAULT_TO : @student_email,
    #   subject: "New Timetable for #{@title} has been uploaded"
    # )
  end

  def update_time_timetable_mail(course)
    # @course = course
    # @title = @course.name
    # users = course.users

    # users.each do |user|
    #   @student_name = user.first_name
    #   @student_email = user.email
    #   mail(
    #     to: check_environment ? DEFAULT_TO : @student_email,
    #     subject: "Updated Timetable for #{@title} has been uploaded"
    #   )
    # end
  end

  def live_classes_mail(day, lesson, course, user)
    # @lesson = lesson
    # @course = course
    # @day = day
    # @emails = user.email
    # mail(
    #   to: check_environment ? DEFAULT_TO : @emails,
    #   subject: "Feedback for #{@day.ordinalize} day of class"
    # )
  end

  def mock_classes_mail(lesson, course, user)
    # @lesson = lesson
    # @course = course
    # @type = @course.product_version.type.underscore.split("_")[0].upcase
    # @emails = user.email
    # mail(
    #   to: check_environment ? DEFAULT_TO : @emails,
    #   subject: "We Hope You Enjoyed your Mock Exam + Recap Day"
    # )
  end

  def inform_old_staff(staff, course)
    @staff = staff
    @course = course
    mail(
      to: check_environment ? DEFAULT_TO : @staff.email,
      subject: "Stream Reallocation - A Course Stream has been reassigned to another tutor"
    )
  end

  def inform_new_staff(staff, course)
    @staff = staff
    @course = course
    mail(
      to: check_environment ? DEFAULT_TO : @staff.email,
      subject: "Stream Reallocation - A Course Stream has been Reassigned to You"
    )
  end

end
