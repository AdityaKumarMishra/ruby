class TextbookDeliveryMailer < ApplicationMailer
	def shipping_confirmation_mail(user, tracking_number)
		@tracking_number = tracking_number
		@user = user
		mail(
      to: check_environment ? DEFAULT_TO : @user.email,
      subject: "GradReady Textbook Shipping Confirmation"
    )
	end
end
