class McqAttempt < ApplicationRecord
  belongs_to :user
  belongs_to :exercise
  belongs_to :mcq_stem
  belongs_to :mcq
  belongs_to :mcq_answer, optional: true
  has_many :mcq_attempt_answers
  validates :exercise, :mcq_stem, :mcq, :user, presence: true
  validate :user_is_same_as_exercise_user
  # mutiple attempts for same questions?
  validates :mcq_id, uniqueness: { scope: [:user_id, :exercise_id] }



  scope :with_tag, -> (tag_ids) {
    includes(mcq: :tagging).where(taggings: { tag_id: tag_ids })
  }

  def self.update_user
    find_each do |e|
      if e.user_id != e.exercise.user_id
        e.user_id = e.exercise.user_id
        e.save
      end
    end
  end

  def user_is_same_as_exercise_user
    user_id == exercise.user_id
  end

  def attempt_with_only_tag tag
    mcq_attempts.includes(:mcq_stem).where(mcq_stems: { published: true }).select{|att| att.mcq.tags.any?{|t| (t == tag) if t }}
  end

  def reset_mcq_statistics
    tag = mcq.tag
    return if tag.nil?
    correct_count = 0
    if mcq_answer.present?
      correct = mcq_answer.correct
      correct_count = correct ? 1 : 0
    end

    tags_ids = tag.self_and_ancestors_ids
    mcq_stats = McqStatistic.where(user_id: user.id, tag_id: tags_ids)
    mcq_stats.update_all("viewed = viewed - 1, correct = correct - #{correct_count}")

    # update used and score percentage
    mcq_stats.each do |mcq_stat|
      mcq_stat.update_score_and_used_percentage
    end
  end
end
