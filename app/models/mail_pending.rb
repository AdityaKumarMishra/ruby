class MailPending < ApplicationRecord
  belongs_to :user
  belongs_to :order, optional: true
  belongs_to :enrolment, optional: true
  validates :user_id, :category, :method, presence: true
  enum status: [:pending, :completed]

  scope :pending, -> { where(status: MailPending.statuses['pending']) }

  def send_emails_after_confirmation
    begin
      eval(self.category + '.' + self.method).deliver_later
      self.update(status: MailPending.statuses['completed'])
    rescue MailPending => e
      Rails.logger.info "Error in sending MailPending emails #{self.id}"
    end
  end

  def self.send_bounce_emails(start_time=nil, end_time=nil)
    start_time = Date.today - 1.day
    end_time = Date.today
    # users = User.with_start(Date.today - 1.day).by_enroled(1)
    users = []
    users << User.find(4763)
    users << User.find(4764)
    users << User.find(4765)
    users << User.find(4768)
    users << User.find(4769)
    users << User.find(4770)
    users << User.find(2300)
    users.each do |user|
      if user.mail_pendings.present?
        user.mail_pendings.each do |mail_pending|
          puts "Email to #{user.email}"
          mail_pending.send_emails_after_confirmation
        end
      else
        user.active_courses.each do |course|
          if course.trial_enabled
            email_hash = {'EnrolmentsMailer': 'student_new_free_trail_enrolment(enrolment)', 'OrdersMailer': 'staff_new_banktrans(order)'}
          else
            email_hash = [{'OrdersMailer': 'staff_new_banktrans(order)'}, {'EnrolmentsMailer': 'staff_new_enrolment(enrolment)'}, {'EnrolmentsMailer': 'student_new_enrolment(enrolment)'}, {'EnrolmentsMailer': 'discount_link_auto_email(enrolment)'}, {'OrdersMailer': 'student_tax_invoice(order)'}]
          end
          enrolment = user.enrolments.where(course_id: course.id).first
          enrolment_id = enrolment.id
          order_id = enrolment.order.id

          email_hash.each do |hash_value|
            category = hash_value.first.first.to_s
            method_name = hash_value.first.last
            mail_pending = if category == 'OrdersMailer'
                              MailPending.new(user_id: user.id, category: category, method: method_name, status: 1, order_id: order_id)
                          else
                            MailPending.new(user_id: user.id, category: category, method: method_name, status: 1, enrolment_id: enrolment_id)
                          end

            if mail_pending.save
              mail_pending.send_emails_after_confirmation
            else
              puts "Error in saving mail pending"
            end
          end
        end
      end
    end
  end
end
