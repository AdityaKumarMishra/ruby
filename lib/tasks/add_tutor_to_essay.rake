namespace :add_tutor_to_essay do
  desc "GRAD-2203 adding tutor for essay responses for assinging different tutor for essays"
  task  add_tutor_to_essay_response: :environment do
    a = []
    EssayResponse.all.each do |essay_response|
      if essay_response.essay_tutor_response.present? && essay_response.essay_tutor_response.staff_profile.present?
        tutor = essay_response.essay_tutor_response.staff_profile.staff
      else
        tutor = essay_response.course.staff_profiles.first.staff
      end
      essay_response.update_attribute(:tutor_id, tutor.id)
    end
  end
end
