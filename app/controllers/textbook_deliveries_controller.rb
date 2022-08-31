class TextbookDeliveriesController < ApplicationController
	before_action :authenticate_user!

  def create_or_update_textbook
    if params[:user_id].present?
	    user = User.find_by(id: params[:user_id])
      if user.present?
        order_id = user.try(:current_enrolment).try(:order).try(:id)
        # textbook_deliveries = user.textbook_deliveries.find_by(enrolment_id: user.try(:current_enrolment).try(:id),order_id: order_id)
        textbook_deliveries = user.try(:textbook_deliveries).last if user.try(:textbook_deliveries).present?
        unless textbook_deliveries.present?
          user.textbook_deliveries.create(enrolment_id: user.try(:current_enrolment).try(:id),date_sent: Date.parse(params[:date_sent]), tracking_number: params[:tracking_number], order_id: order_id, status: params[:status] || 3 )
        else
          textbook_deliveries.update(date_sent: Date.parse(params[:date_sent]), tracking_number: params[:tracking_number], status: params[:status] || 3)
        end
  	    TextbookDeliveryMailer.shipping_confirmation_mail(user,params[:tracking_number]).deliver_now
      end
		else
			flash[:danger] = "Something went wrong!"
		end
    redirect_to textbook_deliveries_path
  end
end
