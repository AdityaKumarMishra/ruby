class StudyBuddiesController < ApplicationController
  before_action :authenticate_user!, only: [:index]
  layout 'layouts/dashboard'

  def index
    params[:filterrific] ||= {}
    @filterrific = initialize_filterrific(
        StudyBuddy,
        params[:filterrific]
    ) || return
    @all_buddies = @filterrific.find.order(created_at: :desc)
    @study_buddies = @all_buddies.paginate(page: params[:page], per_page: 20)
    respond_to do |format|
      format.html
      format.js
      format.xlsx
    end
  end

  def create
    @study_buddy = StudyBuddy.new(study_buddy_params)
    if @study_buddy.save
    flash[:notice] = 'Study Buddy was successfully created.'
      else
        flash[:error] = 'Please review the problems below.'
      end
      redirect_to root_path
  end

  private

  def study_buddy_params
    params.require(:study_buddy).permit(:name, :email, :phone_number, :grad_student, :exam_to_prepare, :university_id, :degree_id, :city , :city_area , :suburb , :focus_area , :focus_study , :buddy_type , :other_info )
  end
end
