namespace :fire_essay_response_email do
  task fetch_details: :environment do
    puts "=============== Task Start ==============="
    email_arr = ["john.maguire344@gmail.com", "annabellaglewis@gmail.com", "hayley.baynham@outlook.com"].uniq
    email_arr.each do |email|
      user = User.find_by(email: email)
      if user.essay_responses.present?
        user.essay_responses.each do |essay_response|
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
      end
    end
    puts "=============== Task End ==============="
  end
end

