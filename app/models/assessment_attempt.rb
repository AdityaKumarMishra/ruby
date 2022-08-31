class AssessmentAttempt < ApplicationRecord
  belongs_to :assessable, polymorphic: true
  belongs_to :user

  has_many :section_attempts, dependent: :destroy
  has_many :section_item_attempts, through: :section_attempts
  has_many :mcqs, through: :section_attempts
  has_one :essay_response, dependent: :destroy
  validates :user, :assessable, presence: true
  validates :assessable_id, uniqueness: { scope: [:course_id, :user, :assessable_type] }
  after_create :create_section_attempts
  after_create :create_online_mock_exam_online_exam
  belongs_to :diagnostic_test, -> { joins(:assessment_attempts).where(assessment_attempts: { assessable_type: 'DiagnosticTest'}) }, foreign_key: 'assessable_id', optional: true
  belongs_to :online_exam, -> { joins(:assessment_attempts).where(assessment_attempts: { assessable_type: 'OnlineExam'}) }, foreign_key: 'assessable_id', optional: true
  belongs_to :online_mock_exam, -> { joins(:assessment_attempts).where(assessment_attempts: { assessable_type: 'OnlineMockExam'}) }, foreign_key: 'assessable_id', optional: true
  scope :completed, -> { where.not(completed_at: nil) }

  enum attempt_mode: ['Online Exam', 'Print Exam Questions']

  def update_mark
    self.mark = section_attempts.sum(:mark)
    completed!
    update_scores
    # calculate_percentile
    save
  end

  def update_scores
    self.section_attempts.order(:section_id).each do |sa|
      total_count = sa.try(:section).try(:mcqs).try(:count)
      if (sa.section.title.include?("Section I") || sa.section.sectionable.title.include?("Section I")) &&  sa.section.position == 1
        self.section_one_score = ((sa.mark / total_count.to_f) * 100).round(2) if sa.mark.present? && total_count.present?

      else
        self.section_three_score = ((sa.mark / total_count.to_f) * 100).round(2) if sa.mark.present? && total_count.present?
      end
      save
    end
  end

  def overall_percentile
    # Perentile Updations
    total_score = (self.section_one_score + self.section_two_score + 2 * self.section_three_score).round(2)
    self.update(total_score: total_score)
    self.percentile = (((number_of_below_score + number_of_same_score).to_f) /AssessmentAttempt.completed.where(assessable: assessable).count * 100).round(2)
    save
    return self.percentile
  end

  def number_of_below_score
    AssessmentAttempt.where(assessable: assessable).completed.where('total_score < ?', total_score).count
  end

  def number_of_same_score
    AssessmentAttempt.where(assessable: assessable).completed.where(total_score: total_score).count
  end

  def essay_percentage(rating)
    ((rating.to_f / 80) * 100).round(2)
  end

  def calculate_essay_percentile
    self.section_two_percentile = (((number_of_below_score_for_essay + number_of_same_score_for_essay).to_f) /AssessmentAttempt.completed.where(assessable: assessable).count * 100).round(2)
    save
    return self.section_two_percentile
  end

  def number_of_below_score_for_essay
    AssessmentAttempt.where(assessable: assessable).completed.where('section_two_raw_score < ?', section_two_raw_score).count
  end

  def number_of_same_score_for_essay
     AssessmentAttempt.where(assessable: assessable).completed.where(section_two_raw_score: section_two_raw_score).count
  end

  # def online_exam_overall_percentile
  #   self.percentile = (((number_of_below_rank + number_of_same_rank).to_f) /AssessmentAttempt.completed.where(assessable: assessable).count * 100).round(1)
  #   save
  #   return self.percentile
  # end

  # def ome1_overall_percentile
  #   if self.assessable_type == "OnlineMockExam"
  #     self.percentile = (((ome1_number_of_below_rank + ome1_number_of_same_rank).to_f) / ome1_total_attempts * 100).round(1)
  #   end
  #   save
  #   return self.percentile
  # end

  # def ome1_ids
  #   OnlineMockExam.where(published: true, per_city_exam_count: 1).pluck(:id)
  # end

  # def ome1_total_attempts
  #   AssessmentAttempt.where("assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineMockExam' AND assessment_attempts.completed_at IS NOT NULL", ome1_ids).count
  # end

  # def ome1_number_of_below_rank
  #   AssessmentAttempt.where("assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineMockExam' AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempts.all_section_score < ?", ome1_ids, self.all_section_score).count
  # end

  # def ome1_number_of_same_rank
  #   AssessmentAttempt.where("assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineMockExam' AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempts.all_section_score = ?", ome1_ids, self.all_section_score).count
  # end

  # def ome2_overall_percentile
  #   if self.assessable_type == "OnlineMockExam"
  #     self.percentile = (((ome_number_of_below_rank + ome_number_of_same_rank).to_f) / ome_total_attempts * 100).round(1)
  #   end
  #   save
  #   return self.percentile
  # end

  # def ome_number_of_below_rank
  #   AssessmentAttempt.where("assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineMockExam' AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempts.mark < ?", ome_ids, self.section_attempts.sum(:mark)).count
  # end

  # def ome_number_of_same_rank
  #   AssessmentAttempt.where("assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineMockExam' AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempts.mark = ?", ome_ids, self.section_attempts.sum(:mark)).count
  # end

  # def ome_ids
  #   OnlineMockExam.where(published: true).pluck(:id)
  # end

  # def ome_total_attempts
  #   AssessmentAttempt.where("assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineMockExam' AND assessment_attempts.completed_at IS NOT NULL", ome_ids).count
  # end

  # def online_mock_exam2_overall_percentile
  #   if self.assessable_type == "OnlineMockExam"
  #     self.percentile = ((online_exam2_number_of_below_rank + 0.5 * online_exam2_number_of_same_rank) / online_exam2_no_of_attempts * 100).round(1)
  #   end
  #   save
  #   return self.percentile
  # end

  # def online_exam2_number_of_below_rank
  #   SectionAttempt.joins(:assessment_attempt).where("((assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?)) OR (assessment_attempts.assessable_type = 'OnlineExam' AND  assessable_id IN (?))) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND assessment_attempts.mark < ?", mock_exam_2_ids, online_exam_ids, self.section_attempts.sum(:mark)).count
  # end

  # def online_exam2_number_of_same_rank
  #   SectionAttempt.joins(:assessment_attempt).where("((assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?)) OR (assessment_attempts.assessable_type = 'OnlineExam' AND  assessable_id IN (?))) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND assessment_attempts.mark = ?", mock_exam_2_ids, online_exam_ids, self.section_attempts.sum(:mark)).count
  # end

  # def online_exam2_no_of_attempts
  #   AssessmentAttempt.where("(assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineExam') OR (assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineMockExam')", online_exam_ids, mock_exam_2_ids).where("assessment_attempts.completed_at IS NOT NULL").count
  # end

  # def online_exam_ids
  #   OnlineExam.where("published = true AND title ilike ?", "%GAMSAT: Exam %" ).pluck(:id)
  # end

  # def mock_exam_2_ids
  #   OnlineMockExam.where("published = true AND per_city_exam_count = ?", 2 ).pluck(:id)
  # end


  # def calculate_percentile
  #   #self.percentile = ((number_of_below_rank + 0.5 * number_of_same_rank)/AssessmentAttempt.completed.where(assessable: assessable).count * 100).round(1)
  #   self.percentile = (((number_of_below_rank + number_of_same_rank).to_f) /AssessmentAttempt.completed.where(assessable: assessable).count * 100).round(2)
  # end

  # def calculate_overall_percentile
  #   # For recalculate old exam percentile for Mock 1 and Mock 2
  #   if self.assessable.try(:per_city_exam_count) == 2
  #     self.percentile = ((number_of_below_rank_live + 0.5 * number_of_same_rank_live) / number_of_attempts_live * 100).round(1)
  #   else
  #     if self.essay_response.present? && self.essay_response.essay_tutor_response.present?
  #       total_mark = self.essay_response.essay_tutor_response.rating.try(:to_i) + total_updated_marks
  #       self.percentile = ((number_of_below_rank_for_essay(total_mark) + 0.5 * number_of_same_rank_for_essay(total_mark)) / number_of_attempts_live * 100).round(1)
  #     else
  #       self.percentile = ((number_of_below_rank_live + 0.5 * number_of_same_rank_live) / number_of_attempts_live * 100).round(1)
  #     end
  #   end
  #   save
  #   return self.percentile
  # end

  # def calculate_essay_percentage ratings
  #   # Added for exam 1 essay percentage (Need Revert)
  #   section_two_per = (section_two_number_of_below_rank_live(ratings) + 0.5 * section_two_number_of_same_rank_live(ratings)) / number_of_attempts_live * 100
  #   section_two_per.round(1)
  # end

  # def section_two_number_of_below_rank_live(section_two_score)
  #   # Added for exam 1 essay percentage (Need Revert)
  #   LiveExam.where('section_two_score < ? AND section_type = ?', section_two_score, 'GamsatReady').count
  # end

  # def section_two_number_of_same_rank_live(section_two_score)
  #   # Added for exam 1 essay percentage (Need Revert)
  #   LiveExam.where(section_two_score: section_two_score, section_type: 'GamsatReady').count
  # end

  # def number_of_below_rank_for_essay(marks)
  #   LiveExam.where('total_score < ? AND section_type = ?', marks, "GamsatReady").count
  # end

  # def number_of_same_rank_for_essay(marks)
  #   LiveExam.where(total_score: marks, section_type: "GamsatReady").count
  # end

  # def number_of_below_rank_live
  #   LiveExam.where('total_score < ? AND section_type = ?', total_updated_marks, "GamsatReady").count
  # end

  # def number_of_same_rank_live
  #   LiveExam.where(total_score: total_updated_marks, section_type: "GamsatReady").count
  # end

  # def number_of_attempts_live
  #   LiveExam.where(section_type: "GamsatReady").count
  # end

  # def total_updated_marks
  #   percentile = ((self.section_attempts.sum(:mark) * 100)/122).to_f if self.section_attempts.present?
  #   total_mark = ((percentile.round(1)*185)/100).to_i if percentile.present?
  #   return total_mark.present? ? total_mark : 0
  # end

  # def number_of_below_rank
  #   AssessmentAttempt.where(assessable: assessable).completed.where('mark < ?', mark).count
  # end

  # def number_of_same_rank
  #   AssessmentAttempt.where(assessable: assessable).completed.where(mark: mark).count
  # end

  def completed!
    self.completed_at = Time.zone.now if section_attempts.completed.count == section_attempts.count
    save
  end

  def is_finish
    #assessable.is_finish
    unless assessable.try(:is_finish).present?
      false
    else
      assessable.is_finish
    end
  end

  # def section_one_percentile
  #   (section_one_number_of_below_rank + 0.5 *
  #   section_one_number_of_same_rank) / self.number_of_attempts * 100 if section_one_score != 0
  # end

  # def section_three_percentile
  #   (section_three_number_of_below_rank + 0.5 *
  #   section_three_number_of_same_rank) / number_of_attempts * 100 if section_three_score != 0
  # end

  # def total_percentile_for_online_mock_exam
  #   ((number_of_below_rank_for_online_mock_exam + 0.5 * number_of_same_rank_for_online_mock_exam) / number_of_attempts * 100).to_f.round(1) if all_sections_completed
  # end

  # def section_one_number_of_below_rank
  #   AssessmentAttempt.where('section_one_score < ? AND section_one_score != 0 AND section_type = ? AND assessable_type = ?', section_one_score, section_type, "OnlineMockExam").count
  # end

  # def section_one_number_of_same_rank
  #   AssessmentAttempt.where(section_one_score: section_one_score, section_type: section_type, assessable_type: "OnlineMockExam").count
  # end

  # def number_of_attempts
  #   AssessmentAttempt.where(section_type: section_type, assessable_type:"OnlineMockExam").count
  # end

  # def section_three_number_of_below_rank
  #   AssessmentAttempt.where('section_three_score < ? AND section_three_score != 0 AND section_type = ? AND assessable_type = ?', section_three_score, section_type, "OnlineMockExam").count
  # end

  # def section_three_number_of_same_rank
  #   AssessmentAttempt.where(section_three_score: section_three_score, section_type: section_type, assessable_type: "OnlineMockExam").count
  # end

  # def number_of_below_rank_for_online_mock_exam
  #   AssessmentAttempt.where.not(section_one_score: 0, section_three_score: 0).where('total_score < ? AND section_type = ? AND assessable_type = ?', total_score, section_type, "OnlineMockExam").count
  # end

  # def all_sections_completed
  #   section_one_score != 0 && section_three_score !=0
  # end

  # def number_of_same_rank_for_online_mock_exam
  #   AssessmentAttempt.where(total_score: total_score, section_type: section_type, assessable_type: "OnlineMockExam").count
  # end


  private

  def create_section_attempts
    unless assessable_type == "OnlineMockExam"
      assessable.sections.each do |section|
        section_attempts.create!(section: section, user: user)
      end
    end
  end

  def create_online_mock_exam_online_exam
    if assessable_type == "OnlineMockExam"
      online_mock_exam_online_exams = self.assessable.online_mock_exam_sections.select{|a| a.section_type == "online_exam"}
      online_mock_exam_essay = self.assessable.online_mock_exam_sections.select{|a| a.section_type == "essay"}
      if online_mock_exam_online_exams.present?
        online_mock_exam_online_exams.each do |exam|
          exam.online_exam.sections.each do |section|
            section_attempts.create!(section: section, user: user)
          end
        end
      end
      if online_mock_exam_essay.present?
        online_mock_exam_essay.each do |es|
          essay = Essay.find_by(id: es.essay_id)
          tutor = StaffProfile.find_by(id: es.staff_id).staff_id
          EssayResponse.create(user: user,essay: essay,tutor_id: tutor,assessment_attempt_id: self.id,expiry_date: es.essay_expire_time, course_id: user.active_course.id)
        end
      end
    end
  end

  # def save_total
  #   if assessable_type == "OnlineMockExam"
  #     self.total_score = (self.section_one_score.nil? ? 0 : self.section_one_score) +  (self.section_two_score.nil? ? 0 : self.section_two_score) + 2 * (self.section_three_score.nil? ? 0 : self.section_three_score)
  #   end
  # end
end
