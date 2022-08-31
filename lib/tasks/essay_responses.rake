namespace :essay_responses do
  task remove_extra_essays: :environment do
    User.all.select{|user| user.essay_responses.count > 15}.each do |user|
      user.essay_responses.order(:id)[10..20].each do |essay_response|
        essay_response.destroy if essay_response.unanswered?
      end
    end
  end

  task assign_ten_essays: :environment do
    User.all.select{|user| user.essay_responses.count > 5 && user.essay_responses.count < 10}.each do |user|
      feature_log = user.feature_logs.select{|fl| fl.master_feature.essay?}.first
      additional_essays = 10 - user.essay_responses.count
      feature_log.assign_essays(false, feature_log.product_version_feature_price.product_version, additional_essays) unless feature_log.nil?
    end
  end

  desc 'Some essays were deleted when they should not have been, this was run on an old database to restore them'
  task export_deleted_essays_json: :environment do
    essay_json = []
    tutor_response_json = []
    tutor_feedback_json = []
    User.all.select{|user| user.essay_responses.count > 15}.each do |user|
      user.essay_responses.each do |essay_response|
        essay = {
            "id": essay_response.id,
            "response": essay_response.response,
            "user_id": essay_response.user_id,
            "created_at": essay_response.created_at,
            "updated_at": essay_response.updated_at,
            "essay_id": essay_response.essay_id,
            "slug": essay_response.slug,
            "activation_date": essay_response.activation_date,
            "expiry_date": essay_response.expiry_date,
            "time_submited": essay_response.time_submited,
            "elapsed_time": essay_response.elapsed_time,
            "status": essay_response.status,
            "course_id": essay_response.course_id
        }
        if essay_response.essay_tutor_response.present?
          tutor_response = {
              "id": essay_response.essay_tutor_response.id,
              "response": essay_response.essay_tutor_response.response,
              "rating": essay_response.essay_tutor_response.rating,
              "essay_response_id": essay_response.essay_tutor_response.essay_response_id,
              "created_at": essay_response.essay_tutor_response.created_at,
              "updated_at": essay_response.essay_tutor_response.updated_at,
              "staff_profile_id": essay_response.essay_tutor_response.staff_profile_id,
              "elapsed_time": essay_response.essay_tutor_response.elapsed_time,
          }
        end
        if essay_response.essay_tutor_feedback.present?
          tutor_feedback = {
              "id": essay_response.essay_tutor_feedback.id,
              "user_id": essay_response.essay_tutor_feedback.user_id,
              "rating": essay_response.essay_tutor_feedback.rating,
              "response": essay_response.essay_tutor_feedback.response,
              "created_at": essay_response.essay_tutor_feedback.created_at,
              "updated_at": essay_response.essay_tutor_feedback.updated_at,
              "essay_response_id": essay_response.essay_tutor_feedback.essay_response_id,
          }
        end
        essay_json << essay
        tutor_response_json << tutor_response if tutor_response.present?
        tutor_feedback_json << tutor_feedback if tutor_feedback.present?
      end
    end
    File.open('essay_responses.json', 'w') do |f|
      f.write(essay_json.to_json)
    end
    File.open('essay_tutor_responses.json', 'w') do |f|
      f.write(tutor_response_json.to_json)
    end
    File.open('essay_tutor_feedbacks.json', 'w') do |f|
      f.write(tutor_feedback_json.to_json)
    end
  end

  desc 'import deleted essays'
  task import_deleted_essays_json: :environment do
    essay_responses = JSON.parse(File.read('essay_responses.json'))
    essay_responses.each do |essay_response|
      next if EssayResponse.find_by_id(essay_response["id"]).present?
      er = EssayResponse.new(ActiveSupport::JSON.decode(essay_response.to_json))
      er.save!
    end
    essay_tutor_responses = JSON.parse(File.read('essay_tutor_responses.json'))
    essay_tutor_responses.each do |essay_tutor_response|
      next if EssayTutorResponse.find_by_id(essay_tutor_response["id"]).present?
      er = EssayTutorResponse.new(ActiveSupport::JSON.decode(essay_tutor_response.to_json))
      er.save!
    end
    essay_tutor_feedbacks = JSON.parse(File.read('essay_tutor_feedbacks.json'))
    essay_tutor_feedbacks.each do |essay_tutor_feedback|
      next if EssayTutorFeedback.find_by_id(essay_tutor_feedback["id"]).present?
      er = EssayTutorFeedback.new(ActiveSupport::JSON.decode(essay_tutor_feedback.to_json))
      er.save!
    end
  end

  task assign_course_to_essay: :environment do
    EssayResponse.where(course_id: nil).find_each do |er|
      course = er.user.courses.first
      er.update(course_id: course.id) if course.present?
    end
  end

  desc "Remove Extra Essay Tutor Response"
  task remove_extra_essay_tutor_response: :environment do
    a = EssayTutorResponse.all.pluck(:essay_response_id)
    h = Hash.new(0)
    a.each{|n| h[n] += 1}
    s = h.sort_by{|k,v| v}.reverse
    s.map{|s| s if  s.last > 1}.compact
    s.each do |essay_id|
      essay_response = EssayResponse.find(essay_id.first)
      tutor_response = essay_response.essay_tutor_response
      EssayTutorResponse.where.not(id: tutor_response.id).where(essay_response_id: essay_response.id).destroy_all
    end
  end
end
