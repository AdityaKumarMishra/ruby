class Exercise < ApplicationRecord
  belongs_to :user
  validates :difficulty, :amount, :user, :name, :tags, presence: true
  validates :amount, numericality: { only_integer: true, greater_than: 0 }
  enum difficulty: [:easy, :medium, :hard, :mixed]
  has_many :mcq_attempts, dependent: :destroy
  has_many :mcq_stems, through: :mcq_attempts
  has_many :mcqs, through: :mcq_attempts
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :mcq_attempt_times, as: :sectionable
  has_many :attempted_mcqs, as: :attemptable, dependent: :destroy
  belongs_to :course

  accepts_nested_attributes_for :taggings
  enum timer_option: {
    'No Timer': 'no_timer',
    'Timer': 'overall_timer'
  }
  scope :active, -> () { where(is_deleted: false) }
  scope :inactive, -> () { where(is_deleted: true) }

  after_create :generate_questions
  before_destroy :remove_ticket_url

  validate :empty_mcq_stems, on: :create
  validates_numericality_of :amount, less_than_or_equal_to: 60, message: "Can't choose more than 60 questions"


  def add_attempted_mcqs
    mcqs.each do |mcq|
      attempted_mcqs.find_or_create_by(mcq_id: mcq.id)
    end
  end
  
  def finish!
    self.completed_at = Time.zone.now
    save(validate: false)
  end

  def create_mcq_attempts(mcq_stem)
    mcq_stem.mcqs.each do |mcq|
      mcq_attempts.find_or_create_by(mcq_stem: mcq_stem, mcq: mcq, user: user)
      attempted_mcqs.find_or_create_by(mcq_id: mcq.id)
    end
  end

  # return an array of all mcq_stems that student can access
  def available_mcq_stems
    final_tag_ids = tags.collect { |tag| tag.self_and_descendants_ids }.flatten.uniq
    attempted_mcq_stems_ids = user.mcq_attempts.includes(:exercise).where(exercises: {course_id: user.active_course.try(:id)}).pluck(:mcq_stem_id).uniq
    # Return all mcqs that have not been attempted and relate to the tags the user selected
    not_completed = McqStem.includes(:tags).where(published: true, examinable: false, difficulty: difficulity_level, tags: { id: final_tag_ids }).references(:tags).where.not(id: attempted_mcq_stems_ids)
  end


  def generate_questions
    # get returned avaliable mcqstems
    answerable_mcq_stems = available_mcq_stems
    while mcq_attempts.size < amount
      # random select one
      random_selected_mcq_stem = answerable_mcq_stems.sample
      # create mcq_attempts
      create_mcq_attempts(random_selected_mcq_stem) if insert?(random_selected_mcq_stem)
      # remove it from avaliable
      answerable_mcq_stems = answerable_mcq_stems.reject{|mcq_stem| mcq_stem == random_selected_mcq_stem}
      break if answerable_mcq_stems.empty?
    end
    if mcq_attempts.size == 0
      create_mcq_attempts(available_mcq_stems.sample)
    end
  end

  # return if we still have slots left for new mcq_sten/mcq
  def insert?(mcq_stem)
    return false if mcq_stem.nil?
    mcq_attempts.size + mcq_stem.mcqs.size <= amount
  end

  def attempts_with_tag tag
    tag_ids = tag.self_and_descendants_ids
    mcq_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where(taggings: { tag_id: tag_ids })
  end

  def show_tag_result tag
    attempts = attempts_with_tag tag
    total = attempts.count
    correct = attempts.where(mcq_answers: {correct: true}).count
    incorrect = attempts.where(mcq_answers: {correct: false}).count
    total_secs = mcq_attempt_times.where(mcq_stem_id: attempts.pluck(:mcq_stem_id)).sum(:total_time)
    total_time = Time.at(total_secs).utc.strftime("%M min %S sec")
    correct_incorrect = correct + incorrect
    time_per_question = if correct_incorrect != 0
                          Time.at(total_secs / correct_incorrect).utc.strftime("%M min %S sec")
                        else
                          ""
                        end
    result = {}
    result['total'] = total
    result['correct'] = correct
    result['incorrect'] = incorrect
    result['total_time'] = total_time
    result['not_attempted'] = total - correct - incorrect
    result['time_per_question'] = time_per_question
    result
  end

  def time_taken_attempts_with_tag(tag)
    mcq_attempts = attempts_with_tag tag
    mcq_ids = mcq_attempts.pluck(:mcq_stem_id)
    secs = mcq_attempt_times.where(mcq_stem_id: mcq_ids).sum(:total_time)
    Time.at(secs).utc.strftime("%M min %S sec") if secs.present?
  end

  def total_time_attempts_with_tag(tag)
    mcq_attempts = attempts_with_tag tag
    mcq_ids = mcq_attempts.collect{|m| m.mcq_stem_id}
    secs = mcq_attempt_times.where(mcq_stem_id: mcq_ids).sum(:total_time)
  end

  def percentage
    correct_mcqs = mcq_attempts.includes(:mcq_answer).where(mcq_answers: {correct: true})
    (correct_mcqs.count.to_f / amount.to_f) * 100
  end


  def mcq_stem_attempt_time(mcq_stem_id)
    if mcq_stem_id.present?
      tot_time = 0
      time = mcq_attempt_times.find_by(mcq_stem_id: mcq_stem_id)
      mcq_stem = mcq_stems.find(mcq_stem_id)
      tot_time = (time.total_time / mcq_stem.mcqs.count) / 60.to_f if time
      tot_time.round(2)
    end
  end

  def attempt_with_only_tag tag
    mcq_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where(taggings: { tag_id: tag.id })
  end

  def update_mcq_statistics(course = nil)
    tags.each do |tag|
      total_mcqs = attempt_with_only_tag tag
      next if total_mcqs.blank?
      correct_count = total_mcqs.where(mcq_answers: {correct: true}).count
      in_correct_count = total_mcqs.where(mcq_answers: {correct: false}).count
      total_count = total_mcqs.count
      tags_ids = tag.self_and_ancestors_ids
      mcq_stats = McqStatistic.where(user_id: user.id, tag_id: tags_ids, course_id: course.try(:id))
      mcq_stats.update_all("viewed = viewed + #{total_count}, correct = correct + #{correct_count} , incorrect = incorrect + #{in_correct_count}")
      # update used and score percentage
      mcq_stats.each do |mcq_stat|
        mcq_stat.update_score_and_used_percentage
      end
    end
  end

  def difficulity_level
    case difficulty
    when 'easy'
      [0..33]
    when 'medium'
      [34..66]
    when 'hard'
      [67..100]
    else
      [0..100]
    end
  end

  def update_mcq_statistics_with_delete(course = nil)
    tags.each do |tag|
      total_mcqs = attempt_with_only_tag tag
      next if total_mcqs.blank?
      correct_count = total_mcqs.select{|att| att.mcq_answer && att.mcq_answer.correct}.count
      in_correct_count = total_mcqs.select{|att| att.mcq_answer && att.mcq_answer.correct == false}.count
      total_count = total_mcqs.count
      tags_ids = tag.self_and_ancestors_ids
      mcq_stats = McqStatistic.where(user_id: user.id, tag_id: tags_ids, course_id: course.try(:id))
      mcq_stats.update_all("viewed = viewed - #{total_count}, correct = correct - #{correct_count}, incorrect = incorrect - #{in_correct_count}")

      # update used and score percentage
      mcq_stats.each do |mcq_stat|
        mcq_stat.update_score_and_used_percentage
      end
    end
  end

  def reset_mcq_attempts(course=nil)
    stems_id = mcq_stems.pluck(:id).uniq
    update_mcq_statistics_with_delete(course)
    if mcq_attempts.destroy_all
      self.update_attribute(:completed_at, nil)
      stems = McqStem.where(id: stems_id)
      stems.each do |stem|
        create_mcq_attempts(stem)
      end
    end
  end

  def self.exercise_question_styles
    {"All Questions on page"=>0, "Single Question per page (ACER Format)"=>1}
  end

  def time_per_question
    return if overall_time.nil?
    if question_style == 0
      (overall_time / mcqs.uniq.count.to_f) * 60
    end
  end

  def question_allotted_time
    return if overall_time.nil?
    if question_style == 0
      (overall_time / mcq_stems.uniq.count.to_f) * 60
    else
      (overall_time / mcqs.uniq.count.to_f) * 60
    end
  end

  def is_finish
    completed_at.present?
  end

  def self.difficulity_level_by_params(diff)
    case diff
    when 'easy'
      [0..33]
    when 'medium'
      [34..66]
    when 'hard'
      [67..100]
    else
      [0..100]
    end
  end

  private

  def empty_mcq_stems
    return unless available_mcq_stems.size == 0
    errors.add(:base, "You have attempted all the questions for selected topic and difficulty")
  end

  def remove_ticket_url
    tickets = Ticket.where(given_type: 'Exercise', given_id: self.id)
    tickets.update_all(given_type: nil, given_id: nil)
  end
end
