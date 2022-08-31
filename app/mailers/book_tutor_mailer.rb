class BookTutorMailer < ApplicationMailer
  layout 'mailer'
  default from: "student.care@gradready.com.au"

  def make_student_booking(booking)
    @student = booking.student
    @tutor = booking.tutor
    @booking = booking
    mail( to: check_environment ? DEFAULT_TO : [@student.email], subject: 'Private Tutoring Booking Confirmation')
  end

  def make_tutor_booking(booking)
    @student = booking.student
    @tutor = booking.tutor
    @booking = booking
    mail( to: check_environment ? DEFAULT_TO : [@tutor.email], subject: 'New Private Tutoring Session')
  end

  def cancel_tutor_booking(booking)
    @student = booking.student
    @tutor = booking.tutor
    @booking = booking
    mail( to: check_environment ? DEFAULT_TO : [@tutor.email], subject: 'Private Tutoring Session Cancelled')
  end

  def check_response_regarding_appointment(appointment)
    @appointment = appointment
    @subject = @appointment.tutor.staff_profile.tags.pluck(:name).join(', ')
    mail(
        to: check_environment ? DEFAULT_TO : [@appointment.student.email, "rordev@ongraph.com"],
        subject: "Have you received a response regarding #{@subject} appointment"
    )
  end

  def appointment_escalate_mail_to_staff(appointment)
    @appointment = appointment
    mail(
        to: check_environment ? DEFAULT_TO : [@appointment.tutor.email, 'quality.assurance@gradready.com.au'],
        subject: "Student #{@appointment.student.first_name} is awaiting for your confirmation regarding their private tutoring appointment"
         
    )
  end

  def appointment_escalate_mail_to_student(appointment)
    @appointment = appointment
    @subject = @appointment.tutor.staff_profile.tags.pluck(:name).join(', ')
    mail(
        to: @appointment.student.email,
        subject: "Escalation request has been sent"
    )
  end

end
