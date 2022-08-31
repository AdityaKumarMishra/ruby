class SectionItemAttempt < ApplicationRecord
  belongs_to :section_attempt
  belongs_to :section_item
  belongs_to :mcq_stem, optional: true
  belongs_to :mcq_answer, optional: true
  has_one :user, through: :section_attempt
  has_one :mcq, through: :section_item
  has_one :assessment_attempt, through: :section_attempt

  validates :section_attempt, :section_item, :mcq_stem, presence: true
  # after_create :update_exam_statistics
  after_destroy :update_exam_statistics_after_delete

  scope :with_tag, -> (tag_ids) {
    includes(mcq: :tagging).where(taggings: { tag_id: tag_ids })
  }

  private

  # def update_exam_statistics
  #   if user.present?
  #     tags_ids = mcq.tagging.tag.self_and_ancestors_ids if mcq.tagging.present? && mcq_stem.published
  #     exam_stats = ExamStatistic.where(tag_id: tags_ids, section_attempt_id: section_attempt_id, user_id: user.id)
  #     exam_stats.update_all('total = total + 1')
  #   end
  # end

  def update_exam_statistics_after_delete
    if user.present? && user.exam_statistics.present?
      tags_ids = mcq.tagging.tag.self_and_ancestors_ids if mcq && mcq.tagging.present?
      sec_attempt_id = self.section_attempt_id
      exam_stats = ExamStatistic.where(tag_id: tags_ids, section_attempt_id: sec_attempt_id, user_id: user.id)
      exam_stats.update_all('total = total - 1')
    end
  end
end
