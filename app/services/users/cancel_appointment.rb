module Users
  class CancelAppointment
    attr_accessor :params, :current_user

    def initialize(params, current_user)
      @params = params
      @current_user = current_user
    end

    class << self
      def call(params, current_user)
        new(params, current_user).call
      end
    end

    def call
      if params[:appointment_id].present?
        appointment = Appointment.find(params[:appointment_id])
        appointment.update(status: :deleted)
        msg = 'Appointment was cancelled successfully.'
      else
        user = User.find(params[:user_id])
        appointments = user.appointments.current.active
        appointments.each do |appointment|
          appointment.update(status: :deleted)
        end
        msg = 'Appointments was cancelled successfully.'
      end

      msg
    end
  end
end
