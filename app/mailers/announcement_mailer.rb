class AnnouncementMailer < ApplicationMailer
  default from: 'student.care@gradready.com.au'
  layout 'mailer'

  def announcement(to, subject, content)
    mail(to: check_environment ? DEFAULT_TO : to, subject: subject) do |format|
      format.html { render inline: content }
    end
  end
end
