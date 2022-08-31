class MailingListSubscriptionsController < ApplicationController
  before_action :set_mailing_list

  def create
    # TODO proper management of subscriptions
    @message = @mailing_list.subscribe!(subscription_params)
  end

  def destroy
    @mailing_list.unsubscribe!(subscription_params[:email])
  end

  private
  def subscription_params
    params.permit(:email, :first_name, :last_name)
  end
  def set_mailing_list
    @mailing_list = MailingList.find_by_name!(params[:list])
  end
end
