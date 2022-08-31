class Mcq < ApplicationRecord
  include EditorParsable

  # enum difficulty: { easy: 1, medium: 50, hard: 99 }
  ratyrate_rateable
  after_save :update_stem_difficulty
  # after_create :update_mcq_statistics
  # after_destroy :update_mcq_statistics_after_delete
  # after_create :update_exam_statistics
  after_create :create_section_item
  # after_destroy :update_exam_statistics_after_delete
  has_many :mcq_answers, -> { default_order }, dependent: :nullify
  belongs_to :mcq_stem
  belongs_to :exam_section, optional: true
  has_many :service_specs
  has_many :section_items, dependent: :nullify
  has_one :tagging, as: :taggable, dependent: :destroy
  has_one :tag, through: :tagging
  has_many :tickets, as: :questionable
  has_one :rating_cache, as: :cacheable
  belongs_to :skill_tag, optional: true

  has_many :mcq_attempts, dependent: :destroy
  has_many :attempted_mcqs, dependent: :destroy
  # before_create :update_tag
  has_one :mcq_video
  accepts_nested_attributes_for :mcq_video, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :mcq_answers, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :tagging

  acts_as_commontable

  validates_presence_of :question, :difficulty, :explanation
  validates_presence_of :tags
  # validates_presence_of :similarity_score
  validates_inclusion_of :examinable, in: [true, false]
  # validates_inclusion_of :publish, in: [true, false]
  validate :validate_answers
  validate :validate_answer_present

  validates :difficulty, numericality: { greater_than: 0 }

  enum display_type: [ :normal, :split_screen, :yes_no ]
  enum skill_tags: [ :compare_and_contrast, :deduction_inferences_and_generalisation, :visualisation_and_pattern_perception, :data_interpretation_extrapolation_and_interpolation, :calculation_and_estimation ]

  # scope :published, -> { where(publish: true) }
  scope :no_exam_section, -> { where(exam_section_id: nil) }
  scope :default_order, -> { order('id ASC') }
  scope :examinable_mcq, -> { includes(:mcq_stem).where(mcq_stems: { examinable: true} ) }

  scope :published_mcq, -> (status){where(mcq_stems: { published: (status=="Yes" ? true : false)}) if status != "All"}

  scope :examinable_mcq_filter, -> (status) do
    if status != "All"
      if status == "MCQ Bank"
        where(mcq_stems: { examinable: false})
      elsif status == 'Online Exams'
        where(mcq_stems: { examinable: true})
      else
        where(mcq_stems: { pool: "tutor_use"})
      end
    end
  end

  scope :online_exam_mcq, -> (exam_id){
    includes(section_items: :section).where('sections.sectionable_type = ? AND sections.sectionable_id = ?', 'OnlineExam', exam_id).references(:sections) if exam_id != "All - Duplicates Not Counted" && exam_id != "All - Duplicates Counted"}

  scope :tagged_by, -> (tag_ids) do
    joins(:tagging).where(taggings: { tag_id: tag_ids })
  end

  def self.examinable_filter (published_status, state=nil)
    if published_status == "Yes"
      filer_mcqs
    elsif published_status == "No"
      mcqs = filer_mcqs
      if state.present?
        joins(:mcq_stem, [section_items: :section]).joins("INNER JOIN online_exams on online_exams.id = sections.sectionable_id").where("online_exams.published = false")
      else
        joins(:mcq_stem, [section_items: :section]).joins("INNER JOIN online_exams on online_exams.id = sections.sectionable_id").where("online_exams.published = false AND mcqs.id NOT IN (?)", mcqs.pluck(:id).uniq)
      end
    else
      joins(:mcq_stem, [section_items: :section]).joins("INNER JOIN online_exams on online_exams.id = sections.sectionable_id")
    end
  end

  def self.filer_mcqs
    joins(:mcq_stem, [section_items: :section]).joins("INNER JOIN online_exams on online_exams.id = sections.sectionable_id").where("online_exams.published = true AND mcq_stems.published = true AND mcq_stems.examinable = true")
  end

  # Hack so you can access mcq.tags in the same way as other content
  def tags
    [tag]
  end

  def name_human
    mcq_stem.title
  end

  def self.not_assign_items(user, quantity)
    additional_mcq = []
    Mcq.all.find_each do |mcq|
      unless user.mcqs.include?(mcq)
        additional_mcq << mcq
        return additional_mcq if additional_mcq.count == quantity
      end
    end
  end

  scope :by_difficulty, lambda { |level|
    return nil  if level.blank?
    where('difficulty BETWEEN ? AND ?', McqStem::DIFFICULTY_LEVELS[level.to_sym][:bottom], McqStem::DIFFICULTY_LEVELS[level.to_sym][:top])
  }

  def self.draw(student, *tag_ids)
    tag_ids.to_a
    tags = Tag.find_by_id(tag_ids.join(',')).to_a
    tags.map(&:mcqs).map { |_mcq| not_answered_by_student(student) }.flatten.sample
  end

  def self.draw_by_name(student, tag_names)
    tags = Tag.where(name: tag_names.split(',')).to_a
    tags.map(&:mcqs).map { |_mcq| not_answered_by_student(student) }.flatten
  end

  def users_answered
    mcq_answers.map { |answer| answer.mcq_student_answers.map(&:user) }.flatten
  end

  def update_tag
    self.tag = mcq_stem.tags.first if tag.nil? && mcq_stem
  end

  def title
    return mcq_stem.title
  end
  def to_s
    question
  end

  def answers
    chars = ('A'..'Z').to_a
    mcq_answers.map.with_index do |answer, index|
      answer.answer.insert(0, "#{chars[index]}) ")
      answer
    end
  end

  def to_html_safe
    question.html_safe
  end

  def correct_answer
    mcq_answers.find_by(correct: true)
  end

  # Returns a URL that we can use in the ticketing forum to link to this content
  def ticket_content_url
    mcq_stem
  end

  def published
    mcq_stem.published
  end

  def fetch_difficulity
    diff = nil
    McqStem::DIFFICULTY_LEVELS.each do |k, v|
      if difficulty.between?(v[:bottom], v[:top])
        diff = v[:default]
      end
    end
    diff
  end

  private

  def validate_answers
    errors.add(:mcq_answers, 'Mcq should have only one correct answer!') if mcq_answers.many? { |answer| answer.correct == true }
  end

  def validate_answer_present
    errors.add(:mcq_answers, "Mcq should have one correct answer!") unless mcq_answers.map(&:correct).include?(true)
  end

  def update_stem_difficulty
    mcq_stem.update_difficulty
  end

  def update_mcq_statistics
    tags_ids = tagging.tag.self_and_ancestors_ids if tagging.present? && mcq_stem.published
    mcq_stats = McqStatistic.where(tag_id: tags_ids)
    mcq_stats.update_all('total = total + 1')

    # update used percentage
    mcq_stats.each do |mcq_stat|
      mcq_stat.update_score_and_used_percentage
    end
  end

  def update_mcq_statistics_after_delete
    tags_ids = tagging.tag.self_and_ancestors_ids if tagging.present?
    mcq_stats = McqStatistic.where(tag_id: tags_ids)
    mcq_stats.update_all('total = total - 1')

    # update used percentage
    mcq_stats.each do |mcq_stat|
      mcq_stat.update_score_and_used_percentage
    end
  end

  def update_exam_statistics
    tags_ids = tagging.tag.self_and_ancestors_ids if tagging.present? && mcq_stem.published
    exam_stats = ExamStatistic.where(tag_id: tags_ids)
    exam_stats.update_all('total = total + 1')
  end

  def update_exam_statistics_after_delete
    tags_ids = tagging.tag.self_and_ancestors_ids if tagging.present?
    exam_stats = ExamStatistic.where(tag_id: tags_ids)
    exam_stats.update_all('total = total - 1')
  end

  def create_section_item
    return unless mcq_stem.examinable
    section_ids = SectionItem.includes(:mcq_stem).where(mcq_stems: { id: mcq_stem.id }).pluck(:section_id).uniq
    section_ids.each do |section_id|
      SectionItem.create(mcq_id: self.id, section_id: section_id)
    end
  end
end
