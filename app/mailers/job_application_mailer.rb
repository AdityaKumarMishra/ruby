class JobApplicationMailer < ApplicationMailer
  layout 'mailer'
  default from: "student.care@gradready.com.au"

  def successful_job_application(job_application)
	  @job_application = job_application
	  mail(to: check_environment ? DEFAULT_TO : @job_application.email, subject: "Successful Job Application")
  end

  def unsuccessful_job_application(job_application)
    @job_application = job_application
    mail(to: check_environment ? DEFAULT_TO : @job_application.email, subject: "Unsuccessful Job Application")
  end

  def student_job_application(job_application)
    @job_application = job_application
    mail(to: check_environment ? DEFAULT_TO : "hr@gradready.com.au", subject: "Job Application submitted successfully")
  end

  def job_application_submitted(job_application)
    @job_application = job_application
    @title = job_application.job_application_form.title
    mail(to: check_environment ? DEFAULT_TO : @job_application.email, subject: "Application Received - #{@title}")
  end

  def certain_period_application(job_application)
    # @job_application = job_application
    # @type = @job_application.application_answers.where(application_question_id: 114).first.content
    # # @type = @job_application.application_answers.first.content
    # mail(to: check_environment ? DEFAULT_TO : @job_application.email, subject: "Information regarding your recent job application for Gradready")
  end

  def rejected_job_application(job_application)
    @job_application = job_application
    mail(to: check_environment ? DEFAULT_TO : @job_application.email, subject: "Your Application Outcome at GradReady")
  end

  def send_initial_assessment(job_application)
    @job_application = job_application
    @title = @job_application.job_application_form.title
    mail(
      to: check_environment ? DEFAULT_TO : @job_application.email,
      subject: "[GradReady] #{@title} Application - #{@job_application.name}"
    )
  end

end
