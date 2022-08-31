env :PATH, ENV['PATH']
set :output, { error: '/var/log/error.log', standard: '/var/log/cron.log' }

every 1.day, at: '12:01 am' do
  rake 'update_exams_percentile:fetch_details'
end

every 1.day, :at => '01:00 am' do
  runner "Ticket.send_enable_reminder"
end

every 1.day, at: '01:30 am' do
  rake 'orders:remove_incomplete_purchases'
end

every 1.day, at: '02:00 am' do
  runner "Ticket.send_reminders"
end

every 1.day, at: '03:00 am' do
  runner "Ticket.send_escalation_reminders"
end

every 1.day, at: '04:00 am' do
  runner "Enrolment.send_free_trial_expiry_mail_after_14_days"
end

every 1.day, at: '05:00 am' do
  runner "EssayResponse.essay_unmarked_reminder"
end

every 1.day, at: '06:00 am' do
  runner "User.send_features_mail"
end

every 1.day, at: '07:00 am' do
  runner "EssayResponse.send_expiry_reminder"
end

every 1.day, at: '08:00 am' do
  runner "Course.send_expiry_notification"
end

every 1.day, at: '09:00 am' do
  # Chnage time to 6 pm for GRAD-2358
  runner "Course.send_live_classes_mail"
end

every 1.day, at: '10:00 am' do
  # Chnage time to 6 pm for GRAD-2358
  runner "Course.send_mock_classes_mail"
end

every 1.day, at: '11:00 am' do
  runner "Enrolment.update_enrolment_trial"
end

# GRAD-2374 - GetClarity - Follow up required mailer

every 1.day, at: '12:00 pm' do
  runner "Ticket.ticket_follow_up_required"
end

# GRAD-2374 - GetClarity - Follow up required mailer
every '0 7 */2 * *' do
  runner "Ticket.ticket_follow_up_required_every_24_hours_after_72_hours"
end

every 1.day, at: '03:00 am' do
  runner "EssayResponse.test_essay_unmarked_reminder"
end

every 1.day, at: '02:00 pm' do
  runner "MockExamEssay.partial_feedback_reminder"
end

every 1.day, at: '03:00 pm' do
  runner "MockExamEssay.overdue_reminder"
end

every 1.day, at: '04:00 pm' do
  runner "Order.send_essay_reminder_mail"
end

every 1.day, at: '05:00 pm' do
  runner "Appointment.escalation_reminder"
end

every 1.day, at: '06:00 pm' do
  runner "Ticket.mark_as_resolved_in_7_days"
end

every 1.day, at: '07:00 pm' do
  runner "Enrolment.unenroll_expired_courses"
end

every 1.day, at: '03:00 pm' do
  runner "EssayResponse.test_essay_unmarked_reminder"
end

every 1.minutes do
  runner "EssayResponse.test_essay_unmarked_reminder"
end
