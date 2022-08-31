namespace :update_live_exam do
  task update_live_exam_score: :environment do
    LiveExam.all.each do |exam|
      total_score = exam.section_one_score + exam.section_two_score + exam.section_three_score
      exam.update_attribute(:total_score, total_score)
    end
  end

  task update_live_exam_percentile: :environment do
    LiveExam.where(total_score: 0).each do |exam|
      exam.update(section_one_percentile: 0.0, section_two_percentile: 0.0, section_three_percentile: 0.0, total_percentile: 0.0)
    end
  end
end
