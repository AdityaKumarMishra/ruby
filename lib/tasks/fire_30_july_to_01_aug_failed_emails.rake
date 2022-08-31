namespace :fire_30_july_to_01_aug_failed_emails do
  task fetch_details: :environment do
    puts "=============== Task Start ==============="

    # tickets = Ticket.where('created_at BETWEEN ? AND ?', ("30/07/2021").to_date.beginning_of_day, ("01/08/2021").to_date.end_of_day)
    # tickets.each do |ticket|
    #   if ticket.feedback == "No"
    #     TicketMailer.confirm_ticket_sent(ticket).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
    #     if ticket.answerer
    #       TicketMailer.new_question_with_answerer(ticket).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
    #     else
    #       staffs = ticket.tags.map(&:staffs).flatten.uniq
    #       staffs.each do |staff|
    #         TicketMailer.new_question(ticket, staff).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
    #       end
    #     end
    #   end
    # end

    # essay_responses = EssayResponse.where('created_at BETWEEN ? AND ?', ("30/07/2021").to_date.beginning_of_day, ("01/08/2021").to_date.end_of_day)
    # essay_responses.each do |essay_response|
    #   if essay_response.status == "unanswered"
    #     if essay_response.tutor.present?
    #       email = essay_response.tutor.email
    #       tutor_emails = email == 'tt@gradready.com.au' ? email : [email, 'tt@gradready.com.au']
    #     else
    #       tutor_emails = essay_response.course.staff_profiles.map{|s| s.staff.email} if essay_response.course.present? && essay_response.course.staff_profiles.present?
    #       tutor_emails = (tutor_emails << 'tt@gradready.com.au').uniq if tutor_emails.present?
    #     end
    #     if tutor_emails.present?
    #       EssayResponseMailer.unmarked_essay(essay_response, tutor_emails).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
    #     else
    #       EssayResponseMailer.no_tutor_essay(essay_response).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
    #     end
    #   end
    #   if essay_response.expiry_date && (essay_response.expiry_date - 7.days).today?
    #     if essay_response.user.active_enrolled_courses.include?(essay_response.course)
    #       EssayResponseMailer.expiry_reminder(essay_response).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
    #     end
    #   end
    #   if essay_response.expiry_date && (essay_response.expiry_date - 2.days).today?
    #     if essay_response.user.active_enrolled_courses.include?(essay_response.course)
    #       EssayResponseMailer.expiry_reminder_before_2_days(essay_response).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
    #     end
    #   end
    #   if essay_response.tutor_id.present? && essay_response.old_tutor_id.present?
    #     tutor = User.find_by(id: essay_response.tutor_id)
    #     EssayResponseMailer.new_tutor_assigned(essay_response).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
    #     EssayResponseMailer.inform_old_tutor(essay_response, tutor).deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
    #   end
    # end

    # essay_tutor_responses = EssayTutorResponse.where('created_at BETWEEN ? AND ?', ("30/07/2021").to_date.beginning_of_day, ("01/08/2021").to_date.end_of_day)
    # essay_tutor_responses.each do |essay_tutor_response|
    #   EssayResponseMailer.marked_essay(essay_tutor_response.essay_response, essay_tutor_response.essay_response.essay_tutor_response.staff_profile).deliver_now
    # end

    users =  User.where('created_at BETWEEN ? AND ?', ("30/07/2021").to_date.beginning_of_day, ("01/08/2021").to_date.end_of_day)
    users.each do |user|
      if user.confirmed_at.present?
        if user.enrolments.present?
          user.enrolments.each do |enrolment|
            EnrolmentsMailer.staff_new_enrolment(enrolment).deliver_now unless enrolment.try(:purchase_item).try(:order).free? ||  enrolment.try(:purchase_item).try(:order).trial?
            EnrolmentsMailer.student_new_enrolment(enrolment).deliver_now
            EnrolmentsMailer.discount_link_auto_email(enrolment).deliver_now if enrolment.try(:order).try(:generated_promo).present?
            purchased_course_type = ProductVersion.course_types[enrolment.course.product_version.course_type]
            OrdersMailer.staff_new_banktrans(enrolment.order).deliver_now if (purchased_course_type == 10 && enrolment.order.present?)
            OrdersMailer.student_tax_invoice(enrolment.order).deliver_now  if enrolment.order.present?
          end
        end
        if user.orders.present?
          user.orders.each do |order|
            if order.paid_at.present?
              order.purchase_items.each do |purchase_item|
                if purchase_item.purchasable_type == "FeatureLog"
                  OrdersMailer.student_tax_invoice(order).deliver_now
                  OrdersMailer.staff_complete_purchase(order).deliver_now
                end
              end
            end
          end
        end
      end
    end
    puts "=============== Task End ==============="
  end
end

