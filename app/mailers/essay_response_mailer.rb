class EssayResponseMailer < ApplicationMailer
  # Note essay_management is defined in application_mailer
  def marked_essay(essay_response, tutor)
    @essay_response = essay_response
    @tutor = tutor
    @user = @essay_response.user
    mail(
        to: check_environment ? DEFAULT_TO : check_environment ? DEFAULT_TO : @user.email,
        subject: "A tutor responded to your essay",
    )
  end

  def unmarked_essay(essay_response, tutor_emails)
    @essay_response = essay_response
    @tutor_emails = tutor_emails
    @student = @essay_response.user
    mail(
      to: check_environment ? DEFAULT_TO : check_environment ? DEFAULT_TO : @tutor_emails,
      subject: "An essay is available to mark"
    )
  end

  def inform_old_tutor(essay_response, tutor)
    @tutor = tutor
    @student = essay_response.user
    @essay = essay_response.essay
    @new_tutor = essay_response.tutor
    mail(
      to: check_environment ? DEFAULT_TO : check_environment ? DEFAULT_TO : tutor.email,
      subject: "Re-assigned Essay - Do Not Mark"
    )
  end

  def new_tutor_assigned(essay_response)
    @essay_response = essay_response
    @essay = essay_response.essay
    @tutor = @essay_response.tutor
    @student = @essay_response.user
    mail(
      to: check_environment ? DEFAULT_TO : @tutor.email,
      subject: "Re-assigned Essay - New Essay for Marking"
    )
  end

  def no_tutor_essay(essay_response)
    # @essay_response = essay_response
    # @student = @essay_response.user
    # @course = @student.courses.first
    # mail(
    #   to: check_environment ? DEFAULT_TO : essay_management,
    #   subject: "There was not tutor to mark this essay"
    # )
  end

  def essay_reminder(essay_response)
    @essay_response = essay_response
    @tutor_email = @essay_response.tutor.email
    @student = @essay_response.user
    @course = @student.courses.first
    @time_diff = (Date.today - (@essay_response.time_submited.to_date + 3.days)).to_i
    if @time_diff == 0
      @msg_subject = "[Overdue Reminder] The essay is now overdue, please mark immediately."
    else
      @msg_subject = "[Overdue Reminder] The essay is now #{@time_diff} day overdue!"
    end
    mail(
      to: check_environment ? DEFAULT_TO : [@tutor_email, quality_assurance_email, "essay.coordinator@gradready.com.au"],
      subject: @msg_subject
      # subject: "[Overdue Reminder] The essay is now overdue, please mark immediately."
    )
  end

  def expiry_reminder(essay_response)
    @essay_response = essay_response
    @student = @essay_response.user
    @essay = @essay_response.essay.title
    @expiry = @essay_response.expiry_date.in_time_zone("Australia/Queensland")
    @expiry_date = @expiry.strftime('%d %b %Y %I:%M %p %Z ').to_s
    mail(
      to: check_environment ? DEFAULT_TO : @student.email,
      subject: "#{@essay} is going to expire in 7 days"
    )
  end

  def expiry_reminder_before_2_days(essay_response)
    @essay_response = essay_response
    @student = @essay_response.user
    @essay = @essay_response.essay.title
    @expiry = @essay_response.expiry_date.in_time_zone("Australia/Queensland")
    @expiry_date = @expiry.strftime('%d %b %Y %I:%M %p %Z ').to_s
    mail(
      to: check_environment ? DEFAULT_TO : @student.email,
      subject: "#{@essay} is going to expire in 48 hours"
    )
  end


  def essay_marking_reminder(count, date, id)
    @date = date
    @count = count
    @staff = StaffProfile.find(id).staff.email
    @tutor = StaffProfile.find(id).staff.full_name
    mail(
      to: check_environment ? DEFAULT_TO : @staff,
      subject: "You will have #{@count} essays to Mark on #{@date}"
    )
  end

  def essay_feedback_tutor_rating(essay_tutor_feedback)
    @essay_tutor_feedback = essay_tutor_feedback
    @rating = @essay_tutor_feedback.rating
    @feedback = @essay_tutor_feedback.response
    @tutor_email = @essay_tutor_feedback.essay_response.tutor.email
    @essay_response = @essay_tutor_feedback.essay_response
    mail(
      to: check_environment ? DEFAULT_TO : [quality_assurance_email, @tutor_email],
      subject: "A student has scored your feedback #{@rating.to_i}"
    )
  end

  def test_essay_reminder
    mail(
      to: check_environment ? DEFAULT_TO : 'deepti.sharma@ongraph.com',
      subject: "This is Test Email"
    )
  end

  def essay_reassignment_email(essay_response, tutor_emails)
    # @essay_response = essay_response
    # @tutor_emails = tutor_emails
    # @student = @essay_response.user
    # mail(
    #   to: check_environment ? DEFAULT_TO : @tutor_emails,
    #   subject: "An essay has been reassigned to you and is available to answer"
    # )
  end
end
