namespace :online_exam_update_position do
  task set_position_for_online_exam: :environment do

    OnlineExam.all.each do |exam|
      exam.update_attribute(:position, nil)
      position = exam.title.split(" ").last
      if position.to_i.to_s == position
        p exam.title
        exam.position = position.to_i
        exam.save
      end
    end
  end

  task remove_assessment_attempt_for_exam_9: :environment do
    AssessmentAttempt.joins(:online_exam).where(online_exams: {title: "GAMSAT Exam 9"}).destroy_all
  end
end

