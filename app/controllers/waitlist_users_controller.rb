class WaitlistUsersController < ApplicationController

  def index
    course = Course.find_by(id: params[:course_id])
    @waitlist_users = course.waitlist_users
    file_name = "Waitlist - #{Date.today}"
    respond_to do |format|
        format.html
        format.js
        format.csv { send_data WaitlistUser.to_csv(@waitlist_users), filename: "#{file_name}.csv" }
      end
  end

  def new 
    @course = Course.find_by(id: params[:course_id])
    @waitlist_user = WaitlistUser.new
  end
    
  def create
    @waitlist_user = WaitlistUser.new(waitlist_user_params)
    respond_to do |format|
        if @waitlist_user.save
          format.html { redirect_back fallback_location: root_path, notice: 'Waitlist was successfully created.' }
        end
      end
  end

  def waitlist_user_params
    params.require(:waitlist_user).permit(:name, :email, :course_id)
  end
end
