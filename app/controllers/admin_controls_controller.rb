class AdminControlsController < ApplicationController
  before_action :find_admin_control, only: [:edit, :show, :update]
  layout 'layouts/dashboard'
  before_action :authenticate_user!
  before_action :check_admin

  def index
    @admin_controls = AdminControl.all
  end

  def edit
  end

  def update
    if @admin_control.update(admin_control_params)
      redirect_to admin_controls_path
    else
      render :edit
    end
  end

  private

  def find_admin_control
    @admin_control = AdminControl.find(params[:id])
  end

  def admin_control_params
    params.require(:admin_control).permit(:name, :new_view)
  end

  def check_admin
    redirect_to root_path and return if current_user.student?
  end
end
