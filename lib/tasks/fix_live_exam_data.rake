namespace :fix_live_exam_data do
  task fix_live_exams: :environment do
    MockExamEssay.all.each do |exam|
      live_exam = LiveExam.find_by(course_id: exam.course_id , user_id: exam.user_id)
      exam.update(live_exam_id: live_exam.id) if live_exam
    end

    mock_exams = []
    MockExamEssay.all.each do |exam|
      live_exam = LiveExam.find_by(course_id: exam.course_id , user_id: exam.user_id)
      mock_exams <<  exam if !live_exam
    end

    mock_exams.each do |mc_exam|
      LiveExam.create(section_one_score: 0, section_two_score: mc_exam.average_rating.round, section_three_score: 0, course_id: mc_exam.course_id, user_id: mc_exam.user_id, section_type: mc_exam.course.product_version.try(:type))
    end

    LiveExam.all.each do |exam|
      mock_exam = exam.mock_exam_essay
      exam.update(section_two_score: mock_exam.average_rating.round) if mock_exam
    end
  end

end
