class LastMinCoursesController < ApplicationController
	before_action :authenticate_user!
	before_action :check_admin
	layout 'layouts/dashboard'

	def new
		@last_min_course = LastMinCourse.new
	end

	def index
		@last_min_course = LastMinCourse.all
	end

	def create
		@last_min_course = LastMinCourse.new(last_min_course_param)
		if @last_min_course.save
			redirect_to last_min_courses_path
			flash[:success] = "Last Minute Preparation Course Created"
		else
			redirect_to new_last_min_course_path
			flash[:error] = @last_min_course.errors.full_messages.join(",")
		end
	end

	def edit
		@last_min_course = LastMinCourse.find_by(id:params[:id])
	end

	def update
		@last_min_course = LastMinCourse.find_by(id:params[:id])
		if @last_min_course.update(last_min_course_param)
			redirect_to last_min_courses_path
		else
			redirect_to last_min_courses_path
			flash[:error] = @last_min_course.errors.full_messages.join(",")
		end
	end

	def destroy
		@last_min_course = LastMinCourse.find(params[:id])
		if @last_min_course.destroy
			redirect_to last_min_courses_path
			flash[:success] = 'Last Min Course Page Course Deleted'
		else
			redirect_to last_min_courses_path
			flash[:error] = @last_min_course.errors.full_messages.join(",")
		end
	end


	private

	def last_min_course_param
		params.require(:last_min_course).permit(:course_name, :date, :amount, :description, :course_type)
	end

	def check_admin
		redirect_to root_path and return if current_user.tutor?
	end

end
