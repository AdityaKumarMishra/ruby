class BraintreeWebhooksController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  # Credit for a lot of the work here comes from a private project by Daniel Tang
  protect_from_forgery with: :null_session
  before_action :set_notification

  def create
    subscription_callbacks = [
        Braintree::WebhookNotification::Kind::SubscriptionCanceled,
        Braintree::WebhookNotification::Kind::SubscriptionWentActive,
        Braintree::WebhookNotification::Kind::SubscriptionWentPastDue,
        Braintree::WebhookNotification::Kind::SubscriptionExpired,
        Braintree::WebhookNotification::Kind::SubscriptionChargedSuccessfully
    ]

    if subscription_callbacks.include? @webhook_notification.kind
      order = Order.find_by_subscription_id(@webhook_notification.subscription.id)
      order.subscription_reload! unless order.nil?
    end
    head :ok
  end

  private
  def set_notification
    begin
      @webhook_notification = Braintree::WebhookNotification.parse(
          params["bt_signature"],
          params["bt_payload"]
      )
    rescue Braintree::InvalidSignature
      head :forbidden
    end
  end
end