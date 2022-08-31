class CountdownTimersController < ApplicationController
  before_action :authenticate_user!
  before_action :set_countdown_timer, only: [:edit, :update]
  before_action :check_admin, only: [:index, :edit, :new, :destroy, :create]
  layout 'layouts/dashboard'
  def index
    @countdown_timers = CountdownTimer.all
  end

  def new
    @countdown_timer = CountdownTimer.new
    respond_with(@countdown_timer)
  end

  def create
    @countdown_timer = CountdownTimer.new(countdown_timer_params)
    if @countdown_timer.save
    flash[:notice] = 'Countdown Timer is successfully created'
      else
        flash[:error] = 'Please review the problems below.'
      end
      redirect_to countdown_timers_path
  end

  def edit
  end

  def update
      @countdown_timer.update(countdown_timer_params)
      redirect_to countdown_timers_path, notice: 'Countdown Timer is successfully updated'
  end

  private

  def set_countdown_timer
    @countdown_timer = CountdownTimer.find(params[:id])
  end

  def countdown_timer_params
    params.require(:countdown_timer).permit(:title, :description, :destination_link, :page_type, :end_date, :end_time, :active)
  end

  def check_admin
    redirect_to root_path and return if current_user.tutor?
  end
end
