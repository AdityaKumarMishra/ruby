namespace :assign_correct_tutor_to_essay do
  task assign_tutor: :environment do
    EssayResponse.where('expiry_date > ?', Time.zone.today).each do |essay_response|
      if essay_response.course.staff_profiles.first.staff.try(:id) != essay_response.tutor_id
        puts "#{essay_response.user.email}"
        essay_response.update_attribute(:tutor_id, essay_response.course.staff_profiles.first.staff.try(:id))
      end
    end
  end
end
