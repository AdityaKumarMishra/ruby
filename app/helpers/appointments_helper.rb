module AppointmentsHelper
  def appointment_actions(appointment)
    if appointment.appointment_hours.sum(:hours) == 0
      link_to('Cancel', appointment_path(appointment), method: :delete, class: 'default_btn hvr-shutter-in-horizontal', data: { confirm: 'Are you sure you want to cancel the appointment?' })
    else
      'Session Completed'
    end
  end
end
