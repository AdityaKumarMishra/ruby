class TutorAvailabilitiesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tutor_availability, only: [:show, :edit, :update, :destroy]
  layout 'layouts/dashboard'
  respond_to :html

  def index
    @user= current_user
    @user.validate_tutor_profile
    @tutor_availabilities = @user.tutor_profile.tutor_availabilities.current.order(start_time: :asc).paginate(page: params[:page])
    respond_with(@tutor_availabilities)
  end

  def show
    respond_with(@tutor_availability)
  end

  def new
    @tutor_availability = TutorAvailability.new
    authorize @tutor_availability
    respond_with(@tutor_availability)
  end

  def edit
  end

  def create
    @tutor_availability = current_user.tutor_profile.tutor_availabilities.new(tutor_availability_params)
    authorize @tutor_availability

    respond_to do |format|
      if @tutor_availability.save
        format.html { redirect_to @tutor_availability, notice: 'Schedule successfully created' }
        format.json { render :show, status: :created, location: @tutor_availability }

      else
        format.html { render :new }
        format.json { render json: @tutor_availability.errors, status: :unprocessable_entity }
        flash[:error] = 'Please review the problems below.'
      end
    end
  end

  def update
    @tutor_availability.update(tutor_availability_params)
    respond_with(@tutor_availability)
  end

  def destroy
    @tutor_availability.status = "deleted"
    respond_with(@tutor_availability)
  end

  private
  def set_tutor_availability
    @tutor_availability = TutorAvailability.find(params[:id])
  end

  def tutor_availability_params
    params.require(:tutor_availability).permit(:start_time, :end_time, :location, :tutor_profile_id, :tutor_schedule_id)
  end


end
