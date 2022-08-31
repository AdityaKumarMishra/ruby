class NotificationsController < ApplicationController
	before_action :authenticate_user!
	before_action :check_admin
	layout 'layouts/dashboard'

	def index
		@notifications = Notification.all
	end

	def new
		@notifications = Notification.new
	end

	def create
		@notifications = Notification.new(notifications_param)
		if @notifications.save
			redirect_to notifications_path, notice: "Notification Updated Successfully"
		else
			redirect_to notifications_path
			flash[:error] = @notifications.errors.full_messages.join(",")
		end
	end

	def edit
		@notifications = Notification.find_by(id: params[:id])
	end
	def update
		@notifications = Notification.find_by(id: params[:id])
		if @notifications.update(notifications_param)
			redirect_to notifications_path, notice: "Notification Updated Successfully"
		else
			redirect_to notifications_path
			flash[:error] = @notifications.errors.full_messages.join(",")
		end
	end

	private

	def notifications_param
		params.require(:notification).permit(:title, :description, :page_type ,:active)
	end

	def check_admin
		redirect_to root_path and return if current_user.tutor?
	end
end