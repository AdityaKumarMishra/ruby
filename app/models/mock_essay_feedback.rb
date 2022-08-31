class MockEssayFeedback < ApplicationRecord
  belongs_to :mock_essay
  belongs_to :user
  validates :rating, :response, presence: true
  after_create :update_status, :update_average_rating, :mail

  scope :with_year_and_month, ->(year, month) {
    where(created_at: Date.new(year,month,1)..Date.new(year,month,-1))
  }

  scope :with_paycycle, ->(start_date, end_date) {
    where('date(mock_essay_feedbacks.created_at) BETWEEN ? AND ?', start_date, end_date)
  }

  private

  def update_status
    mock_exam_essay = self.mock_essay.mock_exam_essay
    if mock_exam_essay.mock_essays.map{|m| m.mock_essay_feedback}.compact.count == 1
      mock_exam_essay.update(status: "partially_marked")
    else
      mock_exam_essay.update(status: "marked", marked_at: Time.zone.now)
    end

  end

  def update_average_rating
    mock_exam_essay = self.mock_essay.mock_exam_essay
    live_exam = LiveExam.find_by(course_id: mock_exam_essay.course_id,user_id: mock_exam_essay.user_id)
    if live_exam
      live_exam.update(section_two_score: mock_exam_essay.average_rating.round)
      total_score = live_exam.section_one_score + live_exam.section_two_score + live_exam.section_three_score
      live_exam.update_attribute(:total_score, total_score)
    end
  end

  def mail
    if ENV['EMAIL_CONFIRMABLE'] != "false"
      mock_exam_essay = self.mock_essay.mock_exam_essay
      if MockExamEssay.statuses[mock_exam_essay.status] == 2
        MockExamEssayMailer.tutor_feedback(self).deliver_later
      end
    end
  end
end
