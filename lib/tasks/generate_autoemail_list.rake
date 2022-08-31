namespace :autoemail do
  task generate_list: :environment do
     require 'net/http'

 require 'openssl'

 require 'resolv-replace'

    Dir['app/mailers/*.rb'].each {|f| require File.basename(f, '.rb')}
    descendants = ApplicationMailer.descendants
    remove_actions = ["test_essay_reminder","new_comment_tutor","feature_auto_email","new_question_with_answerer","announcement","mock_classes_mail","free_trial_expiry_mail_today","live_classes_mail","mark_as_resolved_in_7_days_mail","user_inqury","create_time_timetable_mail","update_time_timetable_mail","no_tutor_essay","low_tutor_mark","inform_tutor","essay_reassignment_email","ticket_feedback","new_question_reminder_no_tags","assigned_ticket_resolved","no_available_essay","certain_period_application","trigger_point","low_rating","new_post_notification","specific_addon_purchase","student_complete_purchase","student_new_banktrans","answer_satisfaction"]
    descendants.each do |mailer|
      actions = mailer.action_methods.to_a.reject {|x| x if ["check_environment", "essay_management", "quality_assurance_email"].include? x}
      actions.each do |action|
        unless remove_actions.include? action.to_s
          params = get_parameters(mailer, action)
          puts "========================================"
          puts "#{mailer} | #{action}"
          puts "#{params}"
          puts "========================================"
          mailer.send(action, *params).deliver_now
        end
      end
    end
  end

  def get_parameters(mailer, action)
    parameters =  mailer.instance_method(action.to_sym).parameters.flat_map{|x| x[1].to_s}
    params = []

    user = User.joins(courses: [:lessons]).where('DATE(courses.expiry_date) > ? AND lessons.lesson_type = 0', Date.today).last(4).first
    course = user.active_course
    lesson = course.lessons.where(lesson_type: 0).first
    staff = StaffProfile.where(id: course.staff_profile_ids).first.staff


    essay_tutor_feedback = EssayTutorFeedback.last
    # essay_tutor_response = EssayTutorResponse.last
    essay_response = essay_tutor_feedback.essay_response
    staff_profile = essay_response.essay_tutor_response.staff_profile
    tutor = staff_profile.staff
    tutor_emails = ['rordev@ongraph.com']

    mcq_stem = McqStem.last
    mcq_stem_user = mcq_stem.reviewer

    order = Order.joins(:generated_promo, purchase_items: [:enrolment]).where("redundant_total_cost IS NOT NULL and redundant_total_cost > ? AND orders.paid_at IS NOT NULL", 0.0).last
    promo = order.generated_promo
    order_email_template = EmailCustomise.includes(:master_features, :courses, :product_versions).where("courses.id IS NULL AND product_versions.id IS NULL AND greeting IS NOT NULL").references(:master_features).last
    textbook_delivery = TextbookDelivery.last

    promo_enrolment = order.purchase_items.first.purchasable

    ticket = Ticket.joins(tags: [:staffs]).find_by(questionable_type: 'Mcq')
    ticket_staff = ticket.tags.map(&:staffs).flatten.uniq.last
    #answerer = ticket.answerer
    current_user = Ticket.order("RANDOM()").first.answerer

    announcement = ManualEmailAnnouncement.joins(courses: [:users]).last
    announcement_user = announcement.courses.first.users.last

    autoemail_id = Autoemail.last.id

    parameters.each do |param|
      case param
      when "to"
        params << "rordev@ongraph.com"
      when "email"
        params << "rordev@ongraph.com"
      when "subject"
        params << "Test Subject"
      when "content"
        params << "<strong>This is a test email generated from User Management &gt; Emails,&nbsp; sending mass emails.&nbsp;</strong>".html_safe
      when "post"
        params << Post.last
      when "first_name"
        params << "ror"
      when "last_name"
        params << "dev"
      when "user"
        if parameters.include? ('mcq_stem')
          params << mcq_stem_user
        elsif parameters.include? ('tracking_number')
          params << textbook_delivery.user
        elsif parameters.include? ('announcement')
          params << announcement_user
        else
          params << user
        end
      when "type"
        params << MailingList.last.type
      when "booking"
        params << Appointment.last
      when "appointment"
        params << Appointment.last
      when "form"
        params << ContactForm.last
      when "course"
        params << course
      when "lesson"
        params << lesson
      when "day"
        params << 3
      when "enrolment"
        if action == 'discount_link_auto_email'
          params << promo_enrolment
        else
          params << Enrolment.joins(:user).where("users.first_name IS NOT Null").last
        end
      when "staff"
        params << staff
      when "email_template"
        if parameters.include? 'order'
          params << order_email_template
        else
          params << EmailCustomise.where.not(greeting: nil).last
        end
      when "essay_tutor_feedback"
        params << EssayTutorFeedback.last
      when "essay_response"
        params << essay_response
      when "tutor"
        if parameters.include? 'question'
          params << ticket_staff
        elsif (action == 'marked_essay') ||  (mailer == EssayTutorMailer)
          params << staff_profile
        else
          params << tutor
        end
      when "tutor_emails"
        params << tutor_emails
      when "count"
        params << 3
      when "date"
        params << Date.today.strftime("%d/%m/%Y")
      when "id"
        params << staff_profile.id
      when "comment"
        if ['new_comment_assignee', 'new_comment_student'].include? action
          params << Comment.find_by(commentable_type: "TicketAnswer")
        elsif mailer == EssayTutorMailer
          params << Comment.find_by(commentable_type: "EssayTutorFeedback")
        else
          params << Comment.last
        end
      when "job_application"
        params << JobApplication.last
      when "mock_exam_essay"
        params << MockExamEssay.last
      when "feedback"
        params << MockEssayFeedback.last
      when "order"
        params << order
      when "promo"
        params << promo
      when "rate"
        params << Rate.last
      when "tracking_number"
        params << textbook_delivery.tracking_number
      when "current_user"
        params << current_user
      when "question"
        params << ticket
      when "ticket"
        params << ticket
      when "answer"
        params << TicketAnswer.last
      when "mcq_stem"
        params << mcq_stem
      when "student"
        params << user
      when "announcement"
        params << announcement
      when "autoemail_id"
        params << autoemail_id
      end
    end
    return params
  end

  def get_category_trigger_points
    case action.to_s
    when "announcement"
      trigger_point = "Sending mass emails from User Management tab"
      category = "Mass Emails"
      recipient  = "All users selected in the list"
    when "blog_mail_to_student"
      trigger_point = "On creating a Blog Post"
      category = "Blog Post"
      recipient  = "All the Blog subscribers, Users with active course and Enquiry Users within last one year"
    when "new_post_notification"
      trigger_point = "NA"
      category = "Blog Post"
      recipient  = "Any particular email specified for sending mail"
    when "welcome_subscription"
      trigger_point = "On subscribing blog"
      category = "Blog Post"
      recipient  = "User who subscribed"
    when "appointment_escalate_mail_to_staff"
      trigger_point = "Escalating Appointment (if no response received from the appointed staff)"
      category = "Private Tutoring"
      recipient  = "Tutor who is escalated"
    when "appointment_escalate_mail_to_student"
      trigger_point = "Escalating Appointment (if no response received from the appointed staff)"
      category = "Private Tutoring"
      recipient  = "Student who has escalated the tutor"
    when "check_response_regarding_appointment"
      trigger_point = "Background job to send escalation reminder email to students in 10 days after appointment"
      category = "Private Tutoring"
      recipient  = "Student who has Appointed the staff"
    when "make_student_booking"
      trigger_point = "On making Appointment"
      category = "Private Tutoring"
      recipient  = "Student who made appointment"
    when "make_tutor_booking"
      trigger_point = "On making Appointment"
      category = "Private Tutoring"
      recipient  = "Staff who has been appointed by student"
    when "course_full_alert"
      trigger_point = "New Enrolments, Course Transfer, Feature log purchase, Addon purchase on course (if 2 enrolment left in full class size)"
      category = "Enrolment"
      recipient  = "payment@gradready.com.au,'michael.qiu@gradready.com.au"
    when "course_full_notification"
      trigger_point = "New Enrolments, Course Transfer, Feature log purchase, Addon purchase on course (if class size is full)"
      category = "Enrolment"
      recipient  = "enrolment@gradready.com.au"
    when "create_time_timetable_mail"
      trigger_point = "New Enrolments, Course Transfer, Addon purchase on course (if class size is full)"
      category = "Enrolment"
      recipient  = "Student who made the purchase (if course is set to send notification to students and visible to students)"
    when "expiry_notification"
      trigger_point = "Background job to check course expired"
      category = "Enrolment"
      recipient  = "Students who has enrolled in the course expired"
    when "expiry_notification_before_7_days"
      trigger_point = "Background job to check course expire before 7 days"
      category = "Enrolment"
      recipient  = "Students who has enrolled in the course about to expire"
    when "inform_new_staff"
      trigger_point = "Updating staff profiles in course"
      category = "Course Management"
      recipient  = "New staff member if any"
    when "inform_old_staff"
      trigger_point = "Updating staff profiles in course"
      category = "Course Management"
      recipient  = "Old staff member if any"
    when "live_classes_mail"
      trigger_point = "Background job to send mail for live classes on same day"
      category = "Course Management"
      recipient  = "student enrolled in live classes course"
    when "mock_classes_mail"
      trigger_point = "Background job to send mail for mock classes on same day"
      category = "Course Management"
      recipient  = "student enrolled in mock classes course"
    when "update_time_timetable_mail"
      trigger_point = "Updating textbook attributes in course"
      category = "Course Management"
      recipient  = "Students enrolled in course (if course is set to send notification to students and visible to students)"
    when "discount_link_auto_email"
      trigger_point = "Any new purchase made like course, feature logs"
      category = "Enrolment"
      recipient  = "Student who made purchase"
    when "enrolment_order_received"
      trigger_point = "On making payment via bank/paypal"
      category = "Payment"
      recipient  = "Student who made purchase"
    when "free_trial_expiry_mail_before_2_days"
      trigger_point = "NA (code is commented)"
      category = "NA"
      recipient  ="Student who is enrolled in course"
    when "free_trial_expiry_mail_today"
      trigger_point = "Background Job to send course expire mail on same day(code is commented)"
      category = "Course Management"
      recipient  = "Student who enrolled in course"
    when "no_available_essay"
      trigger_point = "New enrolment, course transfer, feature logs purchase (master features)"
      category = "Essay Assignment"
      recipient  = "<course city>.manager@gradready.com.au"
    when "staff_new_enrolment"
      trigger_point = "Any new purchase made like course, feature logs"
      category = "Enrolment"
      recipient  = "payment@gradready.com.au"
    when "student_new_customise_enrolment"
      trigger_point = "New enrolment or course transfer as per set from ADMIN"
      category = "Custom Email"
      recipient  = "Student who made purchase"
    when "student_new_enrolment"
      trigger_point = "Any new purchase made like course, feature logs"
      category = "Enrolment"
      recipient  = "Student who made purchase"
    when "student_new_free_trial_enrolment"
      trigger_point = "Free trial signup"
      category = "Course Management"
      recipient  = "Student who enrolled in free trial"
    when "unenrollment_notification"
      trigger_point = "Expired courses and free trial"
      category = "Course Management"
      recipient  = "Student who is enrolled in course"
    when "essay_feedback_tutor_rating"
      trigger_point = "Essay feedback by tutor"
      category = "Essay Marking"
      recipient  = "quality.assurance@gradready.com.au, tutor to whom essay feedback is assigned"
    when "essay_marking_reminder"
      trigger_point = "User signup, New Enrolment, Delete Enrolment, Background Job"
      category = "Essay Marking"
      recipient  = "Staff profiles who to whom course is assigned"
    when "essay_reassignment_email"
      trigger_point = "Update assigned tutor for essay marking"
      category = "Essay Marking"
      recipient  = "New tutor assigned"
    when "essay_reminder"
      trigger_point = "Background Job"
      category = "Essay Marking"
      recipient  = "Tutor to whom essay was assigned, quality_assurance_email"
    when "expiry_reminder"
      trigger_point = "Background Job before 7 days of essay expire date"
      category = "Essay Marking"
      recipient  = "Student"
    when "expiry_reminder_before_2_days"
      trigger_point = "Background Job before 2 days of essay expire date"
      category = "Essay Marking"
      recipient  = "Student"
    when "inform_old_tutor"
      trigger_point = "Update assigned tutor for essay marking"
      category = "Essay Marking"
      recipient  = "Old tutor assigned"
    when "marked_essay"
      trigger_point = "When tutor respond to essay"
      category = "Essay Marking"
      recipient  = "Essay's student"
    when "new_tutor_assigned"
      trigger_point = "Update assigned tutor for essay marking"
      category = "Essay Marking"
      recipient  = "New tutor assigned"
    when "no_tutor_essay"
      trigger_point = "Essay submission by student"
      category = "Essay Marking"
      recipient  = "angie.miles@gradready.com.au"
    when "test_essay_reminder"
      trigger_point = "Background Job to send test email"
      category = "NA"
      recipient  = "NA"
    when "unmarked_essay"
      trigger_point = "Essay submission by student"
      category = "Essay Marking"
      recipient  = "Tutor to whom essay is assigned"
    when "feedback_comment_by_student"
      trigger_point = "Comment by student on essay feedback"
      category = "Essay Marking"
      recipient  = "Tutor who responded on Essay or Marked essay"
    when "feedback_comment_by_tutor"
      trigger_point = "Comment by tutor on essay feedback"
      category = "Essay Marking"
      recipient  = "Student who submitted essay"
    when "inform_tutor"
      trigger_point = "On feedback from student on essay"
      category = "Essay Marking"
      recipient  = "Tutor to whom essay is assigned"
    when "low_tutor_mark"
      trigger_point = "When tutor submit essay rating"
      category = "Essay Marking"
      recipient  = "angie.miles@gradready.com.au"
    when "certain_period_application"
      trigger_point = "job applied for certain period"
      category = "Job Application"
      recipient  = "Candidate who applied for job"
    when "job_application_submitted"
      trigger_point = "New Job Application"
      category = "Job Application"
      recipient  = "Candidate who applied for job"
    when "rejected_job_application"
      trigger_point = "Job Application Rejected"
      category = "Job Application"
      recipient  = "Candidate who applied for job"
    when "send_initial_assessment"
      trigger_point = "Sending initial assessment on job application"
      category = "Job Application"
      recipient  = "Candidate who applied for job"
    when "student_job_application"
      trigger_point = "New Job Application"
      category = "Job Application"
      recipient  = "hr@gradready.com.au"
    when "successful_job_application"
      trigger_point = "Job application status updated to 3.1 Successful Interview"
      category = "Job Application"
      recipient  = "Candidate who applied for job"
    when "unsuccessful_job_application"
      trigger_point = "Job application status updated to 3.2 Unsuccessful Interview"
      category = "Job Application"
      recipient  = "Candidate who applied for job"
    when "announcement_email"
      trigger_point = "Manual announcement email from admin"
      category = "Announcements"
      recipient  = "Selected product versions students"
    when "to_review"
      trigger_point = "New MCQ stem"
      category = "MCQ stem"
      recipient  = "MCQ stem reviewer or course.coordinator@gradready.com.au if no reviewer assigned"
    when "new_mock_essays"
      trigger_point = "New mock exam essay"
      category = "Mock Essay"
      recipient  = "All tutors assigned to this essay"
    when "partial_feeback_mail"
      trigger_point = "Background Job to send mail if essay feedback was provided 3 days ago and not yet marked"
      category = "Mock Essay"
      recipient  = "Tutor Assigned to this essay"
    when "send_overdue_reminder"
      trigger_point = "Background Job to send mail on Mock exam overdue date"
      category = "Mock Essay"
      recipient  = "quality.assurance@gradready.com.au, assigned tutor"
    when "tutor_feedback"
      trigger_point = "Mock essay marked"
      category = "Mock essay"
      recipient  = "Assigned student"
    when "customise_master_feature_mail"
      trigger_point = "on purchase of master feature"
      category = "Custom email"
      recipient  = "Student who made purchase"
    when "promo_applied"
      trigger_point = "when promo is applied on any order"
      category = "Order"
      recipient  = "accounts@gradready.com.au"
    when "promo_shared"
      trigger_point = "Sharing promo code by student"
      category = "Promo code"
      recipient  = "Email submitted by student to share"
    when "specific_addon_purchase"
      trigger_point = "On order/purchase if order includes the master feature 'Gamsat Attendanc eTutorials Feature'"
      category = "Order"
      recipient = "Student who made purchase"
    when "staff_complete_purchase"
      trigger_point = "Purchase done by student"
      category = "Payment"
      recipient  = "payment@gradready.com.au"
    when "staff_new_banktrans"
      trigger_point = "New purchase done by student using bank transfer"
      category = "Payment"
      recipient  = "payment@gradready.com.au"
    when "student_complete_purchase"
      trigger_point = "NA (didn't find any)"
      category = "NA"
      recipient  = "Student who made purchase"
    when "student_new_banktrans"
      trigger_point = "NA (didn't find any)"
      category = "NA"
      recipient  = "Student who made purchase"
    when "student_tax_invoice"
      trigger_point = "Purchase done by student"
      category = "Payment"
      recipient  = "Student who made purchase"
    when "trial_course_congratulation"
      trigger_point = "Activate Trial Course"
      category = "Enrolment"
      recipient  = "Student who purchase trial course"
    when "unsuccessful_purchase"
      trigger_point = "unsuccessful purchase done by student"
      category = "Payment"
      recipient  = "Student who made purchase"
    when "low_rating"
      trigger_point = "NA (Not in use anymore)"
      category = "Rating"
      recipient  = "course.coordinator@gradready.com.au"
    when "rating_feedback"
      trigger_point = "When rating MCQ Stem, MCQ, Video"
      category = "Rating"
      recipient  = "quality.assurance@gradready.com.au"
    when "shipping_confirmation_mail"
      trigger_point = "creating or updating textbook deliveries"
      category = "Textbook Delivery"
      recipient  = "Student for whom textbook delivery is updated"
    when "answer_satisfaction"
      trigger_point = "NA (didn't find any)"
      category = "NA"
      recipient  = "User who asked question"
    when "answer_to_assigned_ticket"
      trigger_point = "When a tutor respond to a ticket"
      category = "Ticket"
      recipient  = "Tutor to whom ticket was assigned"
    when "assigned_ticket_resolved"
      trigger_point = "When ticket is resolved by a tutor"
      category = "Ticket"
      recipient  = "Tutor to whom ticket was assigned"
    when "check_response_regarding_question"
      trigger_point = "Background Job to check if student received reply on ticket"
      category = "Ticket"
      recipient  = "Student who raised ticket"
    when "confirm_ticket_sent"
      trigger_point = "On raising ticket by student"
      category = "Ticket"
      recipient  = "Student"
    when "escalate_mail_to_staff"
      trigger_point = "When student escalate an issue"
      category = "Ticket"
      recipient  = "assigned tutor/staff"
    when "escalate_mail_to_student"
      trigger_point = "Escalation confirmation when student escalate an issue"
      category = "Ticket"
      recipient  = "Student who escalated issue"
    when "new_answer"
      trigger_point = "When a tutor respond to a ticket"
      category = "Ticket"
      recipient  = "Student who asked question"
    when "new_comment_assignee"
      trigger_point = "When any tutor comment  on ticket"
      category = "Ticket"
      recipient  = "Tutor to whom ticket was assigned"
    when "new_comment_student"
      trigger_point = "When any tutor comment  on ticket"
      category = "Ticket"
      recipient  = "Student who raised question"
    when "new_comment_tutor"
      trigger_point = "When any tutor comment  on ticket"
      category = "Ticket"
      recipient  = "Tutor who commented on ticket"
    when "new_question"
      trigger_point = "When student raise a ticket"
      category = "Ticket"
      recipient  = "answerer/staff whom ticket is assigned"
    when "new_question_reminder"
      trigger_point = "Background Job to check response"
      category = "Ticket"
      recipient  = "quality.assurance@gradready.com.au, answerer/staff whom ticket is assigned"
    when "new_question_reminder_no_tags"
      trigger_point = "NA (didn't find any)"
      category = "Ticket"
      recipient  = "staff email,'auto.emails@gradready.com.au','overdue.issues@gradready.com.au"
    when "new_question_with_answerer"
      trigger_point = "NA (Trigger the new question email)"
      category = "NA"
      recipient  = "NA"
    when "ticket_feedback"
      trigger_point = "Student feedback on ticket"
      category = "Ticket"
      recipient  = "staff/answerer of the ticket"
    when "ticket_follow_up_mail"
      trigger_point = "Background job if follow up required on ticket and a date is set"
      category = "Ticket"
      recipient  = "'quality.assurance@gradready.com.au', Ticket answerer mail"
    when "ticket_resolved"
      trigger_point = "When ticket is resolved by a tutor"
      category = "Ticket"
      recipient  = "Student who asked question"
    when "transfer_ticket"
      trigger_point = "Ticket transfer to new tutor/staff"
      category = "Ticket"
      recipient  = "New tutor"
    when "unresolved_reminder"
      trigger_point = "Background job to remind for ticket"
      category = "Ticket"
      recipient  = "answerer of ticket"
    when "feature_auto_email"
      trigger_point = "Background job to send GradReady feature related emails"
      category = "Student emails"
      recipient  = "All users after 7 days of enrolment"
    when "send_first_welcome_email"
      trigger_point = "On user signup"
      category = "Student emails"
      recipient  = "Student Enrolled"
    end
  end
end