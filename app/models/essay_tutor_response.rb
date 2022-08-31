# == Schema Information
#
# Table name: essay_tutor_responses
#
#  id                :integer          not null, primary key
#  response          :text
#  rate              :decimal(10, 2)
#  essay_response_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class EssayTutorResponse < ApplicationRecord
  belongs_to :essay_response
  belongs_to :staff_profile
  validates :rating, :response, presence: true
  validates_uniqueness_of :essay_response_id
  include EditorParsable
  after_create :email_student
  after_create :update_section_two_score

  scope :with_year_and_month, ->(year, month) {
    where(created_at: Date.new(year,month,1)..Date.new(year,month,-1))
  }

  scope :with_paycycle, ->(start_date, end_date) {
    where('essay_tutor_responses.created_at BETWEEN ? AND ?', start_date.to_date.beginning_of_day, end_date.to_date.end_of_day)
  }

  def email_student
    EssayResponseMailer.marked_essay(self.essay_response, essay_response.essay_tutor_response.staff_profile).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
  end

  def update_section_two_score
    if self.essay_response.assessment_attempt.present? && self.essay_response.assessment_attempt.assessable_type == "OnlineMockExam"
      section_two_score = ((self.rating.to_f / 80) *100).round(2)
      self.essay_response.assessment_attempt.update(section_two_score: section_two_score, section_two_raw_score: self.rating.to_i)
    end
  end
end
