class LiveExam < ApplicationRecord
  belongs_to :user
  belongs_to :course
  has_one :mock_exam_essay, dependent: :nullify

  validates :section_one_score, :section_two_score, :section_three_score, :course_id, :user_id, :section_type, presence: true
  validates :section_one_score, :section_three_score, numericality: { greater_than: -1, less_than_or_equal_to: 200 }
  after_create :save_total, :update_mock_exam_essay

  GAMSAT_SECTION = ['Section I - Reasoning in Humanities and Social Sciences', 'Section II - Written Communication', 'Section III - Reasoning in Biological and Physical Sciences'].freeze
  UMAT_SECTION = ['Section I - Logical Reasoning and Problem Solving', 'Section II - Understanding People', 'Section III - Non-verbal Reasoning'].freeze


  def calculate_percentile
    self.section_one_percentile = (section_one_number_of_below_rank + 0.5 *
    section_one_number_of_same_rank) / number_of_attempts * 100 if section_one_score != 0
    self.section_two_percentile = (section_two_number_of_below_rank + 0.5 *
    section_two_number_of_same_rank) / number_of_attempts * 100 if section_two_score != 0
    self.section_three_percentile = (section_three_number_of_below_rank + 0.5 *
    section_three_number_of_same_rank) / number_of_attempts * 100 if section_three_score != 0
    self.total_percentile = (number_of_below_rank + 0.5 * number_of_same_rank) / number_of_attempts * 100 if all_sections_completed
    save
  end

  def section_one_number_of_below_rank
    LiveExam.where('section_one_score < ? AND section_one_score != 0 AND section_type = ?', section_one_score, section_type).count
  end

  def section_one_number_of_same_rank
    LiveExam.where(section_one_score: section_one_score, section_type: section_type).count
  end

  def number_of_attempts
    LiveExam.where(section_type: section_type).count
  end

  def section_two_number_of_below_rank
    LiveExam.where('section_two_score < ? AND section_two_score != 0 AND section_type = ?', section_two_score, section_type).count
  end

  def section_two_number_of_same_rank
    LiveExam.where(section_two_score: section_two_score, section_type: section_type).count
  end

  def section_three_number_of_below_rank
    LiveExam.where('section_three_score < ? AND section_three_score != 0 AND section_type = ?', section_three_score, section_type).count
  end

  def section_three_number_of_same_rank
    LiveExam.where(section_three_score: section_three_score, section_type: section_type).count
  end

  def number_of_below_rank
    LiveExam.where.not(section_one_score: 0, section_two_score: 0, section_three_score: 0).where('total_score < ? AND section_type = ?', total_score, section_type).count
  end

  def all_sections_completed
    section_one_score != 0 && section_two_score !=0 && section_three_score !=0
  end

  def number_of_same_rank
    LiveExam.where(total_score: total_score, section_type: section_type).count
  end

  private
  def save_total
    self.total_score = self.section_one_score + self.section_two_score + self.section_three_score
    save
  end

  def update_mock_exam_essay
    mock_exam_essay = MockExamEssay.find_by(course_id: self.course_id,user_id: self.user_id)
    if mock_exam_essay
      mock_exam_essay.update(live_exam_id: self.id)
    end
  end
end
