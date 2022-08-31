class ContactFormMailer < ApplicationMailer
  layout 'mailer'
  #default from: "contact@gradready.com.au"
  default from: "student.care@gradready.com.au"

  def user_inqury form
    @form = form
    subject = 'Inqury from contact form'
    mail_to = Rails.configuration.default_mail_to
    @form.contact_location.contacts.first if @form.contact_location.contacts.any?
    mail(to: check_environment ? DEFAULT_TO : mail_to, subject: subject)
  end
end
