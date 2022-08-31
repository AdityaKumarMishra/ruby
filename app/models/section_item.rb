class SectionItem < ApplicationRecord
  belongs_to :section
  belongs_to :mcq, optional: true
  has_one :mcq_stem, through: :mcq
  has_many :section_item_attempts, dependent: :destroy

  # validates :mcq, uniqueness: { scope: :section, message: 'Can only add a question once to each section' }
  validates :section, presence: true
  validate :examinable_mcq_stem
  validate :check_lock_exam
  
  private

  def examinable_mcq_stem
    return unless mcq_stem && mcq_stem.examinable == false
    errors.add(:mcq_stem, 'McqStem is not examinable')
  end

  def check_lock_exam
    return unless section.present?
    return unless section.sectionable.locked
    errors.add(:mcq_stem, "can't be added in locked exam.")
  end
end
