class McqStatistic < ApplicationRecord
  belongs_to :user
  belongs_to :tag

  validates :user_id, :tag_id, presence: true

  def update_score_and_used_percentage
    viewed = (self.viewed < 0) ? 0 : self.viewed
    total = (self.total < 0) ? 0 : self.total
    correct = (self.correct < 0) ? 0 : self.correct
    incorrect = (self.incorrect < 0) ? 0 : self.incorrect
    attempted = incorrect + correct
    used = (viewed.to_f / total * 100).nan? ? 0.0 : (viewed.to_f / total * 100).round(1)
    score = (correct.to_f / viewed * 100).nan? ? 0.0 : (correct.to_f / viewed * 100).round(1)

    correct_per = (correct.to_f / attempted * 100).nan? ? 0.0 : (correct.to_f / attempted * 100).round(1)
    self.update(correct: correct, viewed: viewed, total: total, used: used, score: score, correct_per: correct_per)
  end
end
