class MassEmailJob < ApplicationJob
  queue_as :mailers

  def perform(user_ids, subject, content, e_user, blog_mail = nil)
    if ENV['EMAIL_CONFIRMABLE'] != "false"
      if e_user && blog_mail
        MailingListSubscription.where(id: user_ids).find_each do |user|
          AnnouncementMailer.announcement(user.email, subject, content).deliver_later
        end
      elsif e_user
        EnquiryUser.where(id: user_ids).find_each do |user|
          AnnouncementMailer.announcement(user.email, subject, content).deliver_later
        end
      else
        User.where(id: user_ids).find_each do |user|
          AnnouncementMailer.announcement(user.email, subject, content).deliver_later
        end
      end
    end
  end
end
