namespace :mock_exam_essays do
  desc "Add Submitted to Submitted Mock Exam Essays"
  task add_submitted_at: :environment do
    MockExamEssay.where.not(status: 0).each do |mee|
      mee.update_attribute(:submitted_at, mee.mock_essays.last.created_at)
    end
  end
end
