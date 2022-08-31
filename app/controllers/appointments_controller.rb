class AppointmentsController < ApplicationController
  before_action :authenticate_user!, except: [:escalate_appointment_issue]
  before_action :set_appointment, only: [:show, :edit, :update, :destroy]
  layout 'layouts/dashboard'
  respond_to :html

  def make
    @student_id = params[:student_id]
    @tutor_id = params[:tutor_id]
    @course_id = params[:course_id]
    tutor = User.find(params[:tutor_id])
    subjects = tutor.staff_profile.tags.pluck(:name).join(', ')
    @appointment = Appointment.new(content: "Hi ______,<br /><br />I&#39;d like to book a tutoring session with you for #{subjects}. My&nbsp;availabilities are: ________<br /><br />In particular, I am looking for help in particular areas:<br />____<br />____")
  end

  def index
    @appointments = current_user.appointments.active
    respond_with(@appointments)
  end

  def show
  end

  def new
    @appointment = Appointment.new
    respond_with(@appointment)
  end

  def edit
    @appointments = Appointment.where(id: params[:a_ids]) if params[:a_ids].present?
    render 'appointments/edit'
  end

  def create
    if appointment_params[:student_id].present?
      @student = User.find_by(id: appointment_params[:student_id])
      if params[:course_id].present?
        @course = Course.find_by(id: appointment_params[:student_id])
        @student.active_course = @course
      end
    end
    user = @student.present? ? @student : current_user
    path =  if @student.present?
              admin_book_tutor_path(student_id: @student.id, course_id: @course.try(:id))
            else
              dashboard_book_tutor_path
            end
    @appointment = Appointment.new(appointment_params)
    @appointment.student_id = user.id
    if user.private_tutor_time_left > 0 && @appointment.save
      redirect_to path, notice: 'Appointment was created'
    else
      redirect_to path, alert: 'Unable to make booking at this time'
    end
  end

  def update
    if !params[:appointment][:hours].nil?
      hours_to_add = params[:appointment][:hours].to_i
      @appointments = Appointment.where(id: params[:a_ids].split(' ').map(&:to_i)) if params[:a_ids].present?

      if hours_to_add > @appointments&.size.to_i
        redirect_to dashboard_count_tutor_appointments_path(selection: 'Log Hours'), alert: 'Unable to log hours, not enough sessions remaining for student'
        return
      end

      Appointment.transaction do
        (0...hours_to_add).each do |index|
          appointment = @appointments[index]
          appointment_hours = appointment.appointment_hours.create(hours: 1, finish_date: Time.zone.now.to_date)
          params[:appointment][:hours] = appointment.hours + 1

          appointment.update!(appointment_params)
        end

        redirect_to dashboard_count_tutor_appointments_path(selection: 'Log Hours'), notice: 'Successfully logged hour(s)'
      rescue => e
        redirect_to dashboard_count_tutor_appointments_path(selection: 'Log Hours'), alert: 'Unable to log hours'
      end
    end
  end

  def destroy
    if @appointment.can_cancel?
      @appointment.student.active_course = current_course
      @appointment.update(status: :deleted)
      BookTutorMailer.cancel_tutor_booking(@appointment).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
    else
      flash[:error] = current_user.tutor? ? 'You cannot cancel a booking with less than 7 days notice. Please contact either your student or student.services@gradready.com.au if this is an issue.' : 'You cannot cancel a booking with less than 7 days notice. Please contact either your tutor or student.services@gradready.com.au if this is an issue.'
    end
    redirect_back fallback_location: root_path, notice: 'Appointment successfully cancelled'
  end

  def escalate_appointment_issue
    appointment = Appointment.find(params[:id])
    if appointment.escalated?
      redirect_to gamsat_preparation_courses_contact_url, notice: "You have already escalated this appointment. We’ll get back to you shortly."
    else
      appointment.update(escalated: true)
      if ENV['EMAIL_CONFIRMABLE'] != "false"
        BookTutorMailer.appointment_escalate_mail_to_staff(appointment).deliver_later
        BookTutorMailer.appointment_escalate_mail_to_student(appointment).deliver_later
      end
      redirect_to gamsat_preparation_courses_contact_url, notice: "Your appointment has been escalated. We’ll be in touch shortly."
    end
  end

  private
  def set_appointment
    @appointment = Appointment.find(params[:id])
  end

  def appointment_params
    params.require(:appointment).permit(:student_id, :tutor_id, :content, :hours, :course_id)
  end
end
