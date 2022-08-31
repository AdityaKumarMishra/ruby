class SectionAttempt < ApplicationRecord
  belongs_to :section
  belongs_to :assessment_attempt
  has_one :user, through: :assessment_attempt

  has_many :section_item_attempts, dependent: :destroy
  has_many :mcq_stems, through: :section_item_attempts
  has_many :mcqs, through: :section_item_attempts
  has_many :mcq_answers, through: :section_item_attempts
  has_many :mcq_attempt_times, as: :sectionable
  has_many :exam_statistics, dependent: :destroy

  validates :assessment_attempt, :section, presence: true

  after_create :create_section_item_attempts
  before_destroy :remove_ticket_url

  scope :completed, -> { where.not(completed_at: nil) }
  def completed!
    self.completed_at = Time.zone.now
    self.mark = mcq_answers.where(correct: true).count
    save
    assessment_attempt.update_mark if assessment_attempt
  end

  def attempt_with_only_tag tag
    section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where(taggings: { tag_id: tag.id })
  end

  def create_exam_statistics(course_id)
    section_item_tags.each do |tag|
      unless self.exam_statistics.find_by(tag_id: tag.id, course_id: course_id, user_id: user.id).present?
        total_mcqs = attempts_with_tags tag
        self.exam_statistics.create(tag_id: tag.id, course_id: course_id, user_id: user.id, total: total_mcqs.count, time_taken: 0)
      end
    end
  end

  def attempts_with_tags(tag)
    tag_ids = tag.self_and_descendants_ids
    section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where(taggings: { tag_id: tag_ids })
  end

  def update_exam_statistics(course_id)
    create_exam_statistics(course_id)
    section_item_tags.each do |tag|
      total_mcqs = attempt_with_only_tag tag
      next if total_mcqs.blank?
      correct_count = total_mcqs.includes(:mcq_answer).where(mcq_answers: {correct: true}).count
      incorrect_count = total_mcqs.includes(:mcq_answer).where(mcq_answers: {correct: false}).count
      mcq_ids = total_mcqs.pluck(:mcq_stem_id)
      time_count = mcq_attempt_times.where(mcq_stem_id: mcq_ids).sum(:total_time)
      tags_ids = tag.self_and_ancestors_ids
      exam_stats = ExamStatistic.where(user_id: user.id, tag_id: tags_ids, section_attempt_id: self.id)
      exam_stats.update_all("incorrect = incorrect + #{incorrect_count}, correct = correct + #{correct_count}, time_taken = time_taken + #{time_count}")
    end
  end

  # def ome_section_percentile
  #   if self.assessment_attempt.present? && self.assessment_attempt.assessable_type == "OnlineMockExam"
  #     if (self.section.title.include?("Section I") || self.section.sectionable.title.include?("Section I")) &&  self.section.position == 1
  #       self.percentile = ((ome_sec1_number_of_below_rank + ome_sec1_number_of_same_rank).to_f) / ome_total_attempts * 100
  #     else
  #       self.percentile = ((ome_sec3_number_of_below_rank + ome_sec3_number_of_same_rank).to_f) / ome_total_attempts * 100
  #     end
  #   end
  #   save
  # end

  # def ome_ids
  #   OnlineMockExam.where(published: true).pluck(:id)
  # end

  # def ome_sec1_ids
  #   SectionAttempt.joins(:assessment_attempt,:section).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN(?) AND sections.position =? ", ome_ids, 1).pluck(:section_id).uniq
  # end

  # def ome_sec3_ids
  #   SectionAttempt.joins(:assessment_attempt,:section).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN(?) AND sections.position =? ", ome_ids, 2).pluck(:section_id).uniq
  # end

  # def ome_total_attempts
  #   AssessmentAttempt.where("assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineMockExam' AND assessment_attempts.completed_at IS NOT NULL", ome_ids).count
  # end

  # def ome_sec1_number_of_below_rank
  #   SectionAttempt.joins(:assessment_attempt).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark < ?", ome_ids, ome_sec1_ids, self.mark).count
  # end

  # def ome_sec1_number_of_same_rank
  #   SectionAttempt.joins(:assessment_attempt).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark = ?", ome_ids, ome_sec1_ids, self.mark).count
  # end

  # def ome_sec3_number_of_below_rank
  #   SectionAttempt.joins(:assessment_attempt).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark < ?", ome_ids, ome_sec3_ids, self.mark).count
  # end

  # def ome_sec3_number_of_same_rank
  #   SectionAttempt.joins(:assessment_attempt).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark = ?", ome_ids, ome_sec3_ids, self.mark).count
  # end

  # New section 1 and section 3 percentile based on Online Exam
  # def online_mock_exam_section_percentile
  #   if self.assessment_attempt.present? && self.assessment_attempt.assessable.try(:per_city_exam_count) == 1
  #     # New section 1 and section 3 percentile based on Online Exam 1
  #     if (self.section.title.include?("Section I") || self.section.sectionable.title.include?("Section I")) &&  self.section.position == 1
  #       self.percentile = (online_exam_1_section_1_number_of_below_rank + 0.5 * online_exam_1_section_1_number_of_same_rank) / online_exam1_no_of_attempts * 100
  #     else
  #       self.percentile = (online_exam_1_section_3_number_of_below_rank + 0.5 * online_exam_1_section_3_number_of_same_rank) / online_exam1_no_of_attempts * 100
  #     end
  #   else
  #     # New section 1 and section 3 percentile based on Online Exam 2
  #     if (self.section.title.include?("Section I") || self.section.sectionable.title.include?("Section I")) &&  self.section.position == 1
  #       self.percentile = (online_exam_2_section_1_number_of_below_rank + 0.5 * online_exam_2_section_1_number_of_same_rank) / online_exam2_no_of_attempts * 100
  #     else
  #       self.percentile = (online_exam_2_section_3_number_of_below_rank + 0.5 * online_exam_2_section_3_number_of_same_rank) / online_exam2_no_of_attempts * 100
  #     end
  #   end
  #   save
  # end

  # def online_exam_ids
  #   OnlineExam.where("published = true AND title ilike ?", "%GAMSAT: Exam %" ).pluck(:id)
  # end

  # def mock_exam_1_ids
  #   OnlineMockExam.where("published = true AND per_city_exam_count = ?", 1 ).pluck(:id)
  # end

  # def mock_exam_2_ids
  #   OnlineMockExam.where("published = true AND per_city_exam_count = ?", 2 ).pluck(:id)
  # end

  # def online_exam_1_section_1_ids
  #   Section.where(sectionable_id: online_exam_ids + mock_exam_1_ids, position: 1).pluck(:id)
  # end

  # def online_exam_1_section_3_ids
  #   Section.where(sectionable_id: online_exam_ids + mock_exam_1_ids, position: 2).pluck(:id)
  # end

  # def online_exam_2_section_1_ids
  #   Section.where(sectionable_id: online_exam_ids + mock_exam_2_ids, position: 1).pluck(:id)
  # end

  # def online_exam_2_section_3_ids
  #   Section.where(sectionable_id: online_exam_ids + mock_exam_2_ids, position: 2).pluck(:id)
  # end

  # def online_exam_1_section_1_number_of_below_rank
  #   SectionAttempt.joins(:assessment_attempt).where("((assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?)) OR (assessment_attempts.assessable_type = 'OnlineExam' AND  assessable_id IN (?))) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark < ?", mock_exam_1_ids, online_exam_ids, online_exam_1_section_1_ids, self.mark).count

  # end

  # def online_exam_1_section_1_number_of_same_rank
  #   SectionAttempt.joins(:assessment_attempt).where("((assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?)) OR (assessment_attempts.assessable_type = 'OnlineExam' AND  assessable_id IN (?))) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark = ?", mock_exam_1_ids, online_exam_ids, online_exam_1_section_1_ids, self.mark).count
  # end

  # def online_exam_1_section_3_number_of_below_rank
  #   SectionAttempt.joins(:assessment_attempt).where("((assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?)) OR (assessment_attempts.assessable_type = 'OnlineExam' AND  assessable_id IN (?))) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark < ?", mock_exam_1_ids, online_exam_ids, online_exam_1_section_3_ids, self.mark).count

  # end

  # def online_exam_1_section_3_number_of_same_rank
  #   SectionAttempt.joins(:assessment_attempt).where("((assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?)) OR (assessment_attempts.assessable_type = 'OnlineExam' AND  assessable_id IN (?))) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark = ?", mock_exam_1_ids, online_exam_ids, online_exam_1_section_3_ids, self.mark).count
  # end

  # def online_exam_2_section_1_number_of_below_rank
  #   SectionAttempt.joins(:assessment_attempt).where("((assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?)) OR (assessment_attempts.assessable_type = 'OnlineExam' AND  assessable_id IN (?))) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark < ?", mock_exam_2_ids, online_exam_ids, online_exam_2_section_1_ids, self.mark).count

  # end

  # def online_exam_2_section_1_number_of_same_rank
  #   SectionAttempt.joins(:assessment_attempt).where("((assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?)) OR (assessment_attempts.assessable_type = 'OnlineExam' AND  assessable_id IN (?))) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark = ?", mock_exam_2_ids, online_exam_ids, online_exam_2_section_1_ids, self.mark).count
  # end

  # def online_exam_2_section_3_number_of_below_rank
  #   SectionAttempt.joins(:assessment_attempt).where("((assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?)) OR (assessment_attempts.assessable_type = 'OnlineExam' AND  assessable_id IN (?))) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark < ?", mock_exam_2_ids, online_exam_ids, online_exam_2_section_3_ids, self.mark).count

  # end

  # def online_exam_2_section_3_number_of_same_rank
  #   SectionAttempt.joins(:assessment_attempt).where("((assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id IN (?)) OR (assessment_attempts.assessable_type = 'OnlineExam' AND  assessable_id IN (?))) AND assessment_attempts.completed_at IS NOT NULL AND assessment_attempt_id IS NOT NULL AND section_attempts.section_id IN (?) AND section_attempts.mark = ?", mock_exam_2_ids, online_exam_ids, online_exam_2_section_3_ids, self.mark).count
  # end

  # def online_exam1_no_of_attempts
  #   AssessmentAttempt.where("(assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineExam') OR (assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineMockExam')", online_exam_ids, mock_exam_1_ids).where("assessment_attempts.completed_at IS NOT NULL").count
  # end

  # def online_exam2_no_of_attempts
  #   AssessmentAttempt.where("(assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineExam') OR (assessment_attempts.assessable_id IN (?) AND assessment_attempts.assessable_type = 'OnlineMockExam')", online_exam_ids, mock_exam_2_ids).where("assessment_attempts.completed_at IS NOT NULL").count
  # end

  def calculate_percentile
    # self.percentile = (number_of_below_rank + 0.5 *number_of_same_rank) / section.number_of_attempts * 100
    ActiveRecord::Base.transaction do
      begin
        self.percentile = ((number_of_below_rank + number_of_same_rank).to_f) / number_of_attempts * 100
        save
      rescue => ex
      end
    end
  end

  # def section_one_number_of_below_rank_live(section_one_score)
  #   LiveExam.where('section_one_score < ? AND section_type = ?', section_one_score, "GamsatReady").count
  # end

  # def section_one_number_of_same_rank_live(section_one_score)
  #   LiveExam.where(section_one_score: section_one_score, section_type: "GamsatReady").count
  # end

  # def section_three_number_of_below_rank_live(section_three_score)
  #   LiveExam.where('section_three_score < ? AND section_type = ?', section_three_score, "GamsatReady").count
  # end

  # def section_three_number_of_same_rank_live(section_three_score)
  #   LiveExam.where(section_three_score: section_three_score, section_type: "GamsatReady").count
  # end

  # def number_of_attempts_live
  #   LiveExam.where(section_type: "GamsatReady").count
  # end

  def number_of_below_rank
    section.section_attempts.joins(:assessment_attempt).where('section_attempts.mark < ? AND section_attempts.completed_at IS NOT NULL AND assessment_attempts.completed_at IS NOT NULL', mark).count
    # section.section_attempts.where('mark < ?', mark).completed.count
  end

  def number_of_same_rank
    section.section_attempts.joins(:assessment_attempt).where('section_attempts.mark = ? AND section_attempts.completed_at IS NOT NULL AND assessment_attempts.completed_at IS NOT NULL', mark).count
    # section.section_attempts.where(mark: mark).completed.count
  end

  def number_of_attempts
    section.section_attempts.joins(:assessment_attempt).where('section_attempts.completed_at IS NOT NULL AND assessment_attempts.completed_at IS NOT NULL').count
  end

  def correct(sec_tag = nil)
    sec_tag ||= section.sectionable.tags.first
    correct_ans = self.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where(mcq_answers: { correct: true })
    correct_ans = correct_ans.where(taggings: { tag_id: sec_tag.self_and_descendants_ids }) if sec_tag.present?
    correct_ans
  end

  def incorrect(sec_tag = nil)
    sec_tag ||= section.sectionable.tags.first
    incorrect_ans = self.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where(mcq_answers: { correct: false })
    incorrect_ans = incorrect_ans.where(taggings: { tag_id: sec_tag.self_and_descendants_ids }) if sec_tag.present?
    incorrect_ans
  end

  def total(sec_tag = nil)
    sec_tag ||= section.sectionable.tags.first
    total_ques = self.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {})
    total_ques = total_ques.where(taggings: { tag_id: sec_tag.self_and_descendants_ids }) if sec_tag.present?
    total_ques
  end

  def correct_count(sec_tag = nil)
    correct(sec_tag).count
  end

  def incorrect_count(sec_tag = nil)
    incorrect(sec_tag).count
  end

  def total_count(sec_tag = nil)
    total(sec_tag).count
  end

  def parent_tags
    if self.section.sectionable.tags.count > 0
      # self.section_item_attempts.joins(mcq: { tagging: {} }, mcq_answer: {}).where(taggings: { tag_id: section.sectionable.tags.first.self_and_descendants_ids }).map(&:mcq_answer).map(&:mcq).map(&:tag).uniq
      rec = section.sectionable.tags.first.descendants
      # rec.reject{|t| (rec.map(&:id)).include?(t.parent_id)}
    else
      nil
    end
  end

  def section_item_tags
    mcqs.includes(tag: :parent).where.not(tags: {id: nil}).references(:tags).map{|m| m.tag.self_and_ancestors}.flatten.uniq
  end

  def attempts_with_tag tag
    section_item_attempts.select{|att| att.mcq.tags.any?{|t| t.self_and_ancestors.include?(tag) if t }}
  end

  def time_taken_attempts_with_tag(tag)
    section_item_attempts = attempts_with_tag tag
    mcq_ids = section_item_attempts.collect{|m| m.mcq_stem_id}
    secs = mcq_attempt_times.where(mcq_stem_id: mcq_ids).sum(:total_time)
    Time.at(secs).utc.strftime("%M min %S sec")
  end

  def mcq_stem_attempt_time(mcq_stem_id)
    time = mcq_attempt_times.find_by(mcq_stem_id: mcq_stem_id)
    mcq_stem = mcq_stems.find(mcq_stem_id)
    secs = time.present? ? time.total_time : 0
    mcqs_count = mcq_stem.mcqs.count
    secs = mcqs_count > 0 ? secs / mcqs_count : 0
    Time.at(secs).utc.strftime("%M min %S sec")
  end

  def total_time_taken
    secs = mcq_attempt_times.sum(:total_time)
    Time.at(secs).utc.strftime("%M min %S sec")
  end

  def question_allotted_time
    if assessment_attempt.question_style == 0
      (section.duration / mcq_stems.uniq.count.to_f) * 60
    else
      (section.duration / mcqs.uniq.count.to_f) * 60
    end
  end

  private

  def create_section_item_attempts
    section.section_items.includes(:mcq_stem).where(mcq_stems: {published: true, examinable: true }).each do |si|
      section_item_attempts.create!(section_item: si, mcq_stem: si.mcq_stem,
                                    mcq: si.mcq)
    end
  end

  def remove_ticket_url
    tickets = Ticket.where(given_type: 'SectionAttempt', given_id: self.id)
    tickets.update_all(given_type: nil, given_id: nil)
  end
end
