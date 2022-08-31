class Section < ApplicationRecord
  belongs_to :sectionable, polymorphic: true, optional: true
  validates :title, :duration, :sectionable, :position, presence: true
  validates :position, uniqueness: { scope: :sectionable }, numericality: { only_integer: true, greater_than: 0 }
  validates :duration, numericality: { only_integer: true, greater_than: 0 }
  has_many :section_items, dependent: :destroy
  has_many :mcq_stems, through: :section_items
  has_many :mcqs, through: :section_items
  has_many :section_attempts, dependent: :destroy

  def to_s
    title
  end

  def number_of_attempts
    section_attempts.completed.count
  end

  def calculate_percentile
    section_attempts.each(&:calculate_percentile)
  end
end
