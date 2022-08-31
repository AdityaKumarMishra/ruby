namespace :destroy_responses do
  desc 'Go through and destroy all essay responses whose related enrolment is already destroyed.'
  task destroy_essay_responses_without_enrolment: :environment do

    responses = []
    no_responses = []

    EssayResponse.all.each do |res|
      enrolment = res.user.enrolments.where(course_id: res.course_id)
      if enrolment.present?
        responses << res
      else
        res.destroy
      end
    end
  end
end
