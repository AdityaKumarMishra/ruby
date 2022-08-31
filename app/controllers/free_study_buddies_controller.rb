class FreeStudyBuddiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_free_study_buddy, only: [:edit, :update, :show]
  before_action :check_admin, only: [:index, :edit, :new, :destroy, :create]
  layout 'layouts/dashboard'
  def index
    if params[:service_type] == 'free_study_guide'
      @free_stud_buddy = FreeStudyBuddy.find_by(service_type: 1)
    else
      @free_stud_buddy = FreeStudyBuddy.first
    end
  end

  def new
    @free_stud_buddy = FreeStudyBuddy.new
    respond_with(@free_stud_buddy)
  end

  def show
    redirect_to "/404"
  end

  def create
    @free_stud_buddy = FreeStudyBuddy.new(free_study_buddy_params)
    if @free_stud_buddy.save
    flash[:notice] = 'Free Study Buddy Service was successfully created.'
      else
        flash[:error] = 'Please review the problems below.'
      end
      redirect_to free_study_buddies_path
  end

  def edit
  end

  def update
    if params[:active] == "true"
      if params[:study_buddy] == "false"
        FreeStudyBuddy.find_by(title: "GAMSAT Free Trial").update(active: true)
      else
        FreeStudyBuddy.first.update(active: true)
      end
      render :index
    elsif params[:active] == "false"
      FreeStudyBuddy.update_all(active: false)
      render :index
    else
      
      @free_stud_buddy.update(free_study_buddy_params)
      flash[:notice] = 'Free Study Buddy Service was successfully updated.'
      redirect_to free_study_buddies_path
    end
  end

  private

  def set_free_study_buddy
    @free_stud_buddy = FreeStudyBuddy.find(params[:id])
  end

  def free_study_buddy_params
    params.require(:free_study_buddy).permit(:title, :button_text, :description, :active, :info_text)
  end

  def check_admin
    redirect_to root_path and return if current_user.tutor?
  end

end