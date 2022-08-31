class ApplicationMailer < ActionMailer::Base
  default from: "student.care@gradready.com.au"
  layout 'mailer'

  DEFAULT_TO = ['test.catchall@gradready.com.au', 'rordev@ongraph.com']
  #after_action :log_email

  def essay_management
    "angie.miles@gradready.com.au"
  end

  def quality_assurance_email
    "quality.assurance@gradready.com.au"
  end

  def check_environment
    if(Rails.env == 'stage')
      return true
    else
      return false
    end
  end

  private
  def log_email
    mailer_class = self.class.to_s
    mailer_action = self.action_name
    EmailDelivery.log("#{mailer_action}", message)
  end

end
