class TransferTransaction < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :course, optional: true
  attr_reader :reference


  public
  def self.generate_reference
    reference = (0...8).map { (65 + rand(26)).chr }.join
    while self.exists?(banking_reference: reference)
      reference = (0...8).map { (65 + rand(26)).chr }.join
    end
    return reference
  end

  def enrol_student
    if self.paid
      @enrolment = Enrolment.create(user: self.user,course_id: self.course_id)
      @enrolment.subtotal = self.course.price
      @enrolment.gst = self.course.tax
      @enrolment.banktrans = self.banking_reference
      @enrolment.paid_at = self.payment_confirmed
      @enrolment.save!
    end
  end

  def mail_users
    EnrolmentsMailer.staff_new_banktrans(self).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
    ### Mailer don't have this method any more ####
      # EnrolmentsMailer.student_new_banktrans(self).deliver_later
  end
end
