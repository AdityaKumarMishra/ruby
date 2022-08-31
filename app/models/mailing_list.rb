class MailingList < ApplicationRecord
  has_many :mailing_list_subscriptions, dependent: :destroy
  has_many :users, through: :mailing_list_subscriptions

  def subscribe!(options = {})

    subscription = MailingListSubscription.new(mailing_list: self)

    # TODO prevent multiple subscriptions for the same user/email
    already_subscribed = MailingListSubscription.find_by(mailing_list_id: self.id,
                                                          email: options[:email]
                                                        )
    return "You have already subscribed to our #{type} Blog using the below email." if already_subscribed.present?

    unless options[:user].nil?
      subscription.user = options[:user]
    else
      subscription.first_name = options[:first_name]
      subscription.last_name = options[:last_name]
      subscription.email = options[:email]
    end
    if subscription.save
      msg = "Thank you for subscribing to our #{type} Blog!!"
      user = User.find_by(email: subscription.email)
      unsub_email = UnsubscribeEmail.find_by(user_id: user.id)
      if !unsub_email.present?
        BlogPostMailer.welcome_subscription(type, subscription.email).deliver_later
      end
    else
      msg = subscription.errors.full_messages.join(", ")
    end
    msg
  end

  def unsubscribe!(email)
    self.mailing_list_subscriptions.with_email(email).destroy_all
  end

  def type
    case name
    when 'blog_gamsat'
      'GAMSAT'
    when 'blog_umat'
      'UMAT'
    when 'blog_hsc'
      'HSC'
    else
      'VCE'
    end
  end
end
