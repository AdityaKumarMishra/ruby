namespace :update_mailing_list_subscriptions do
  task update_mailing_list: :environment do
    MailingListSubscription.all.each do |mail_list|
      valid_email = /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i
      if (mail_list.email =~ valid_email) != 0
        mail_list.destroy
      end
    end
  end
  task create_timestamp_mailing_list: :environment do
    MailingListSubscription.all.each do |mail_list|
      mail_list.update(created_at: Time.now, updated_at:Time.now)
    end
  end
  # Destroy duplicate mails for user Jannturksoy@hotmail.com
  task destroy_duplicate_mailing_list: :environment do
    mail_subs = MailingListSubscription.find(9,10,11)
    mail_subs.each do |duplicate|
      duplicate.destroy
    end
  end
end
