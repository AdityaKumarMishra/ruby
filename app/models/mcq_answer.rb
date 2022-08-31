# == Schema Information
#
# Table name: mcq_answers
#
#  id         :integer          not null, primary key
#  answer     :text
#  correct    :boolean
#  mcq_id     :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class McqAnswer < ApplicationRecord
  belongs_to :mcq, optional: true
  has_many :mcq_attempts, dependent: :nullify
  has_one :section_item_attempt,dependent: :nullify
  before_destroy :destroy_section_item_attempts
  acts_as_commontable

  validates_presence_of :answer

  scope :default_order, -> {order('id ASC')}

  def truncated_answer
    self.answer.truncate(50, omission: '...')
  end

  def fetch_answer_picked_percentage
    per = 0
    picked_count = mcq_attempts.count
    picked_count += SectionItemAttempt.where(mcq_answer_id: self.id).count
    total_picked_count = McqAttempt.where(mcq_answer_id: McqAnswer.where(mcq_id: mcq_id).ids).count
    total_picked_count += SectionItemAttempt.where(mcq_answer_id: McqAnswer.where(mcq_id: mcq_id).ids).count
    per = ((picked_count.to_f / total_picked_count.to_f) * 100).round if total_picked_count > 0
    per
  end

  def destroy_section_item_attempts
    SectionItemAttempt.where(mcq_answer_id: self.id).update_all(mcq_answer_id: nil)
  end
end
