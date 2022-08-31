class ExamStatistic < ApplicationRecord
  belongs_to :user
  belongs_to :tag, optional: true
  belongs_to :section_attempt, optional: true

  validates :user_id, :tag_id,  :section_attempt_id, presence: true

  def taken_time
    Time.at(time_taken).utc.strftime("%M min %S sec")
  end

  def score
    total!=0 ? (correct.to_f / total * 100).nan? ? 0.0 : (correct.to_f / total * 100).round(1) : 0.0
  end

  def total_time_section
    time_taken
  end

end
