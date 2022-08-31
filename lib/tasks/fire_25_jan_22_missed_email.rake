namespace :fire_25_jan_22_missed_email do
  task fetch_details: :environment do
    puts "=============== Task Start ==============="

    users = User.where('created_at BETWEEN ? AND ?', ("24/01/2022").to_date.beginning_of_day, ("25/01/2022").to_date.end_of_day)
    users.each do |user|
      if user.confirmed_at.present? && user.email.count('.') < 7
        if user.enrolments.present?
          user.enrolments.each do |enrolment|
            unless enrolment.try(:purchase_item).try(:order).free?
              if enrolment.order.present? && enrolment.order.paid_at.present?
                EnrolmentsMailer.staff_new_enrolment(enrolment).deliver_now
                EnrolmentsMailer.student_new_enrolment(enrolment).deliver_now
                EnrolmentsMailer.discount_link_auto_email(enrolment).deliver_now if enrolment.try(:order).try(:generated_promo).present?
                purchased_course_type = ProductVersion.course_types[enrolment.course.product_version.course_type]
                OrdersMailer.staff_new_banktrans(enrolment.order).deliver_now if (purchased_course_type == 10 && enrolment.order.present?)
                OrdersMailer.student_tax_invoice(enrolment.order).deliver_now  if enrolment.order.present?
                OrdersMailer.staff_complete_purchase(enrolment.order).deliver_now
              end
            end
          end
        end
      end
    end

    essay_responses = EssayResponse.where('time_submited BETWEEN ? AND ?', ("24/01/2022").to_date.beginning_of_day, ("25/01/2022").to_date.end_of_day)
    essay_responses.each do |essay_response|
      if essay_response.status == "unmarked"
        if essay_response.tutor.present?
          email = essay_response.tutor.email
          tutor_emails = email == 'tt@gradready.com.au' ? email : [email, 'tt@gradready.com.au']
        else
          tutor_emails = essay_response.course.staff_profiles.map{|s| s.staff.email} if essay_response.course.present? && essay_response.course.staff_profiles.present?
          tutor_emails = (tutor_emails << 'tt@gradready.com.au').uniq if tutor_emails.present?
        end
        if tutor_emails.present?
          EssayResponseMailer.unmarked_essay(essay_response, tutor_emails).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
        else
          EssayResponseMailer.no_tutor_essay(essay_response).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
        end
      end
    end

    essay_tutor_responses = EssayTutorResponse.where('created_at BETWEEN ? AND ?', ("24/01/2022").to_date.beginning_of_day, ("25/01/2022").to_date.end_of_day)
    essay_tutor_responses.each do |essay_tutor_response|
      EssayResponseMailer.marked_essay(essay_tutor_response.essay_response, essay_tutor_response.essay_response.essay_tutor_response.staff_profile).deliver_now
    end

    tickets = Ticket.where('created_at BETWEEN ? AND ?', ("24/01/2022").to_date.beginning_of_day, ("25/01/2022").to_date.end_of_day)
    tickets.each do |ticket|
      if ticket.feedback == "No"
        TicketMailer.confirm_ticket_sent(ticket).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
        if ticket.answerer
          TicketMailer.new_question_with_answerer(ticket).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
        else
          staffs = ticket.tags.map(&:staffs).flatten.uniq
          staffs.each do |staff|
            TicketMailer.new_question(ticket, staff).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
          end
        end
      end
    end


    ticket_answers = TicketAnswer.where('created_at BETWEEN ? AND ?', ("24/01/2022").to_date.beginning_of_day, ("25/01/2022").to_date.end_of_day)
    ticket_answers.each do |ticket_answer|
      TicketMailer.new_answer(ticket_answer).deliver_now
      TicketMailer.answer_to_assigned_ticket(ticket_answer).deliver_now if ticket_answer.user != ticket_answer.ticket.answerer
    end
    puts "=============== Task End ==============="
  end
end

