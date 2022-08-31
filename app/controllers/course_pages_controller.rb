class CoursePagesController < ApplicationController
	before_action :check_admin
	before_action :authenticate_user!
	layout 'layouts/dashboard'

	def index
		@course_pages = CoursePage.all
	end

	def update
		@course_pages = CoursePage.find(params[:id])
		@course_pages.update(active_page: true)
		redirect_to course_pages_path
	end

	private
	def check_admin
		redirect_to root_path and return if current_user.tutor?
	end

end
