class ManualEmailAnnouncementMailer < ApplicationMailer
  require 'open-uri'
  default from: 'student.care@gradready.com.au'
  layout 'mailer'

  def announcement_email(user, announcement)
    @student = user
    @announcement = announcement
    if @announcement.first_docuemnt.file?
      attachments[@announcement.first_docuemnt_file_name]  = {
        mime_type: 'application/pdf',
        content: open(@announcement.first_docuemnt.url).read
      }
    end
    if @announcement.second_docuemnt.file?
      attachments[@announcement.second_docuemnt_file_name]  = {
        mime_type: 'application/pdf',
        content: open(@announcement.second_docuemnt.url).read
      }
    end
    if @announcement.third_docuemnt.file?
      attachments[@announcement.third_docuemnt_file_name]  = {
        mime_type: 'application/pdf',
        content: open(@announcement.third_docuemnt.url).read
      }
    end
    mail(to: check_environment ? DEFAULT_TO : @student.email, subject: "#{@announcement.subject}")
  end
end

