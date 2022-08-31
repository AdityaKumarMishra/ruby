namespace :assessment_attempt do
  task update_percentile_online_exam_attempts: :environment do
    OnlineExam.all.each do |assessable|
      AssessmentAttempt.where(assessable: assessable).each do |attempt|
        attempt.calculate_percentile
        attempt.save
      end
    end
  end
end
