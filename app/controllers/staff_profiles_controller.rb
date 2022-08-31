class StaffProfilesController < ApplicationController
  before_action :set_staff_profile, only: [:show, :edit, :update, :destroy]



  def search
    @staff_profiles = StaffProfile.search_descendant_tags(params[:search])
    @return_path = params[:return_path]
  end

  def append
    @staff_profile = StaffProfile.find(params[:staff_profile_id])
    authorize @staff_profile
    @attribute = params[:attribute]
    @div = params[:div]
  end


  def answerers_for_staff_profiles
    staff_profiles = StaffProfile.answerers_for_staff_profiles
    render json: staff_profiles
  end

  private

  def staff_profile_params
    params.require(:staff_profile).permit(:name, :description, :course_staff)
  end
end
