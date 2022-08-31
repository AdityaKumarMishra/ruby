class TutorSchedulesController < ApplicationController
  before_action :authenticate_user!
  before_action :set_tutor_schedule, only: [:show, :edit, :update, :destroy, :availabilities]
  layout 'layouts/dashboard'
  respond_to :html

  def index
    current_user.validate_tutor_profile
    @tutor_schedules = current_user.tutor_schedules.where('end_time > now()')
  end

  def show
  end

  def new
    @user= current_user
    @user.validate_tutor_profile if !@user.student?
    @tutor_schedule = TutorSchedule.new
    authorize @tutor_schedule
    respond_with(@tutor_schedule)
  end

  def edit
  end

  def create
    @tutor_schedule = current_user.tutor_profile.tutor_schedules.new(tutor_schedules_params )
    authorize @tutor_schedule
    @tutor_schedule.save ? flash[:notice] = 'TutorSchedule was successfully created.' : flash[:error] = 'Please review the problems below.'
    respond_with(@tutor_schedule, location: dashboard_count_tutor_appointments_path(selection: 'Log Hours'))
  end

  def update
    @tutor_schedule.update(tutor_schedules_params)
    respond_with(@tutor_schedule, location: dashboard_count_tutor_appointments_path(selection: 'Log Hours'))
  end

  def destroy
    flag = false
    @tutor_schedule.tutor_availabilities.each do |t|
      if t.appointments.where(status: 0).present?
        t.appointments.each do |a|
          flag = true if a.student.role == "student"
        end
      end
    end
    if flag == true
      redirect_back fallback_location: root_path
      flash[:error] = "Cannot destroy this schedule as it is having bookings."
    else
      @tutor_schedule.destroy
      respond_with(@tutor_schedule, location: dashboard_count_tutor_appointments_path(selection: 'Log Hours'))
    end
  end

  def availabilities
    @tutor_availabilities = @tutor_schedule.tutor_availabilities.order(start_time: :asc)
    @time_slots = TutorAvailability.split_all(@tutor_availabilities, User.superadmin.first.appointment_length).sort_by{|e| e[1][0]}.paginate(page: params[:page])
  end

  private
  def set_tutor_schedule
    @tutor_schedule = TutorSchedule.find(params[:id])
  end

  def tutor_schedules_params
    params.require(:tutor_schedule).permit(:start_time, :end_time, :allow_booking_until, :repeatability, :location)
  end
end
