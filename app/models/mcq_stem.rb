# == Schema Information
#
# Table name: mcq_stems
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  tag_id      :integer
#  author_id   :integer
#  student_id  :integer
#

class McqStem < ApplicationRecord
  include EditorParsable

  # before_save :update_mcqs_tag
  ratyrate_rateable
  # after_update :update_mcq_stem
  # after_update :update_mcq_exam

  belongs_to :author, class_name: 'User'
  belongs_to :reviewer, class_name: 'User',optional: true 
  belongs_to :reviewer2, class_name: 'User',optional: true 
  belongs_to :video_explainer, class_name: 'User',optional: true
  belongs_to :video_reviewer, class_name: 'User',optional: true
  has_many :mcq_hours, dependent: :nullify
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  has_many :mcq_attempts, dependent: :destroy
  has_many :mcqs, dependent: :destroy
  has_many :courses, -> { distinct }, through: :subjects
  has_many :subject_mcq_stems, dependent: :destroy
  has_many :subjects, -> { prototypes }, through: :subject_mcq_stems, dependent: :nullify
  has_many :stem_students, dependent: :destroy
  has_many :users, through: :stem_students
  has_many :tickets, as: :questionable
  has_many :section_items, through: :mcqs
  has_many :section_item_attempts, dependent: :nullify
  belongs_to :skill_tag, optional: true

  validates_presence_of :author, :difficulty, :reviewer
  validates_presence_of :skill_tag
  validates_presence_of :similarity_score

  ##Added for GRAD-3481
  validate :validate_work_directory

  ##Commentout for GRAD-3182p
  # validates_presence_of :title, :description, :author, :difficulty, :reviewer
  # validates :title, uniqueness: true
  # validate :validate_can_publish, on: [:create, :update]
  # validate :validate_lock_exam

  validates_presence_of :tags
  accepts_nested_attributes_for :taggings
  # mcq_stems = Mcq.answered_by_student(current_user).map(&:mcq_stem)
  accepts_nested_attributes_for :mcqs, reject_if: :all_blank, allow_destroy: true
  before_save :set_work_status_updated_time, if: ->{ work_status_changed? }
  before_save :set_published

  enum status: [:published, :not_published]
  enum pool: [:exercise, :exam, :tutor_use]
  enum work_status: [:not_started, :initial_writing , :ready_for_review_1,:rewrites_per_first_review, :discard, :ready_for_review_2, :review_2_complete, :graphics_briefed, :graphics_supplied, :graphics_adjustment_needed, :graphics_complete, :video_explanation_in_progress, :video_explanation_complete, :video_explanation_redo, :formatting_complete_published]
  enum display_type: [ :normal, :split_screen, :yes_no ]

  DIFFICULTY_LEVELS = {
    easy: {bottom: 0, default: 1, top: 33},
    medium: {bottom: 34, default: 50, top: 66},
    hard: {bottom: 67, default: 100, top: 100}
  }.freeze

  filterrific(
    default_filter_params: {sorted_by: 'created_at_desc'},
    available_filters: [
      :sorted_by,
      :search_query,
      :last_updated,
      :with_tag_id,
      :with_skill_tag_id,
      :with_similarity_score,
      :with_author_id,
      :with_reviewer_id,
      :with_difficulty,
      :with_que_pool,
      :with_exam,
      :with_exam_id,
      :with_rating,
      :with_reviewer2_id,
      :with_video_reviewer_id,
      :with_video_explainer_id,
      :with_pool,
      :with_work,
      :with_status,
      :with_start,
      :with_end,
      :with_min,
      :with_max,
      :with_graphic,
      :work_status_updated_at_min_days,
      :work_status_updated_at_max_days
    ]
  )

  scope :with_tag_id, ->(tag_id) { with_tag(tag_id) }
  scope :with_skill_tag_id, ->(skill_id) { where(skill_tag_id: skill_id) }
  scope :with_similarity_score, ->(score) {where(similarity_score: score)}
  scope :published, lambda { where(published: true) }
  scope :non_published, lambda { where(published: false) }
  scope :non_examinable, lambda { where(examinable: false) }
  scope :examinable, lambda { where(examinable: true) }
  # scope :with_tag_name, ->(with_tag_name) { joins(:tags).where('tags.name = ?', with_tag_name) }
  scope :with_author_id, lambda {|author_id| where(author_id: author_id) if author_id.present? }

  scope :with_reviewer_id, lambda { |reviewer_id|
                            if reviewer_id == "Not Reviewed"
                              where(reviewed: false)
                            elsif reviewer_id == "Reviewed"
                              where(reviewed: true)
                            else
                              where(reviewer_id: reviewer_id) 
                            end
                          }
  scope :with_reviewer2_id, lambda { |reviewer2_id|
                            
                            where(reviewer2_id: reviewer2_id)
                          }

  scope :with_video_reviewer_id, lambda{|video_reviewer_id| (where(video_reviewer_id: video_reviewer_id ))}
  scope :with_video_explainer_id, lambda{|video_explainer_id| (where(video_explainer_id: video_explainer_id ))}

  scope :with_start, -> (with_start) do
    begin
      DateTime.parse with_start
      where("mcq_stems.created_at >= ?", with_start)
    rescue ArgumentError
    end
  end

  scope :with_end, -> (with_end) do
    begin
      DateTime.parse with_end
      where("mcq_stems.created_at <= ?", with_end)
    rescue ArgumentError
    end
  end

  scope :last_updated, -> (updated_date) do
    begin
      updated_date = DateTime.parse(updated_date).in_time_zone("Australia/Melbourne")
      where("mcq_stems.updated_at <= ?", updated_date.end_of_day)
    rescue ArgumentError
    end
  end

  scope :with_difficulty, lambda { |level|
      return nil if level.blank?
      query = []
      if level.include? "mixed"
        query << "mcq_stems.difficulty=-1" 
        level.delete('mixed')
      end
      query << (['mcq_stems.difficulty BETWEEN ? AND ?'] * level.count).join(' OR ')
      level.flat_map{|x| query << McqStem::DIFFICULTY_LEVELS[x.to_sym][:bottom] && query << McqStem::DIFFICULTY_LEVELS[x.to_sym][:top]}
      where(query)
    }

  scope :with_graphic, lambda { |option|
        where(graphics_required: option)
      }

  # scope :with_publish, lambda { |option|
  #       where(published: option)
  #     }                                                    strings.map &:to_sym

  scope :with_status, lambda { |option|
        where(status: option.to_i)
      }

  scope :with_work, lambda { |option|
        where(work_status:  option.compact_blank) unless option.compact_blank.empty?
      }
  scope :with_que_pool, lambda { |option|
    where(examinable: option)
  }
  scope :with_pool, lambda { |option|
    if option.to_i != 1
      where(pool: option.to_i)
    end
  }

  scope :with_min, lambda { |option|
    joins(:mcqs).group('mcq_stems.id').having("count(mcq_stem_id) >= #{option}")
  }

  scope :with_max, lambda { |option|
    joins(:mcqs).group('mcq_stems.id').having("count(mcq_stem_id) <= #{option}")
  }

  scope :work_status_updated_at_min_days, lambda { |option|
    min_time = Time.zone.now - option.to_i.days
    where('work_status_updated_at >= ?', option.to_date)
  }

  scope :work_status_updated_at_max_days, lambda { |option|
    max_time = Time.zone.now - option.to_i.days
    where('work_status_updated_at <= ?', option.to_date)
  }

  scope :with_exam, lambda { |option|
    if option == "true"
      includes(:section_items).where.not(section_items: { mcq_id: nil })
    else
      includes(:section_items).where(section_items: { mcq_id: nil })
    end
  }

  scope :with_exam_id, -> (exam_id){}
  scope :with_rating, lambda { |option|
    stem_ids = Rate.where(rateable_type: "McqStem").pluck(:rateable_id)
    stem_arr = []
    stem_ids.each do |stem_id|
      stem = McqStem.find(stem_id)
      if stem.avg_rating <= option && stem.avg_rating >= 0.5
        stem_arr << stem_id
      end
    end
    McqStem.where(id: stem_arr)
  }

  scope :sorted_by, lambda { |sort_option|
        # extract the sort direction from the param value.
        direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
        case sort_option.to_s
          when /^created_at_/
            order("mcq_stems.created_at #{direction}")
          when /^title_/
            order(title: direction)
          when /^tag_name_/
            order(:tags)
          # when /^tag_name_/
          #   order("LOWER(tags.name) #{direction}").includes([:tag, :taggings])
          else
            fail(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
        end
      }

  scope :search_query, lambda { |query|
        # Searches the students table on the 'first_name' and 'last_name' columns.
        # Matches using LIKE, automatically appends '%' to each term.
        # LIKE is case INsensitive with MySQL, however it is case
        # sensitive with PostGreSQL. To make it work in both worlds,
        # we downcase everything.
        return nil if query.blank?
        term = query.to_s.downcase
        # replace "*" with "%" for wildcard searches,
        # append '%', remove duplicate '%'s
        term = ('%' + term.tr('*', '%').tr('\'','\\') + '%').gsub(/%+/, '%')
        where('(LOWER(mcq_stems.title) LIKE ?)', term)
      }

  # A user has access to an MCQ Stem if they're staff,
  # or if they're a student who has relevant tags, and there's one or more tickets for the MCQ Stem
  def has_access?(user)
    if user.student?
      (tickets.any? || mcqs.any? {|mcq| mcq.tickets.any?}) &&
          (tags & user.tags).any?
    else
      true
    end
  end

  def set_work_status_updated_time
    self.work_status_updated_at = Time.zone.now
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

  def avg_rating
    self_rates = self.rates.to_a
    (self_rates.map(&:stars).sum/self_rates.count).to_f.round(1) rescue 0
  end

  def has_difficulty
    if difficulty.between?(McqStem::DIFFICULTY_LEVELS[:easy][:bottom],McqStem::DIFFICULTY_LEVELS[:easy][:top])
      return 0
    elsif difficulty.between?(McqStem::DIFFICULTY_LEVELS[:medium][:bottom],McqStem::DIFFICULTY_LEVELS[:medium][:top])
      return 1
    elsif difficulty.between?(McqStem::DIFFICULTY_LEVELS[:hard][:bottom],McqStem::DIFFICULTY_LEVELS[:hard][:top])
      return 2
    end
    return 3
  end

  def update_mcq_exam
    if examinable_changed?
      SectionItem.includes(:mcq_stem).where(mcq_stems: { id: self.id }).destroy_all unless examinable
      self.mcqs.each do |m|
        tags_ids = m.tagging.tag.self_and_ancestors_ids if m.tagging.present?
        mcq_stats = McqStatistic.where(tag_id: tags_ids)
        if examinable
          mcq_stats.update_all('total = total - 1')
        else
          mcq_stats.update_all('total = total + 1')
        end
        mcq_stats.each do |mcq_stat|
          mcq_stat.update_score_and_used_percentage
        end
      end
    end
  end

  def update_mcq_stem
    if published_changed?
      self.mcqs.each do |m|
        tags_ids = m.tagging.tag.self_and_ancestors_ids if m.tagging.present?
        mcq_stats = McqStatistic.where(tag_id: tags_ids)
        if published
          mcq_stats.update_all('total = total + 1')
        else
          mcq_stats.update_all('total = total - 1')
        end
        mcq_stats.each do |mcq_stat|
          mcq_stat.update_score_and_used_percentage
        end
      end
    end
  end

  def self.dificulty_levels
    McqStem::DIFFICULTY_LEVELS.map(&:first)
  end

  def calculate_difficulty
    if mcqs.any?
      mcqs.sum(:difficulty) / mcqs.count
    else
      0
    end
  end

  def self.options_for_select_score
    (0..5).to_a
  end

  def update_difficulty
    return unless autogenerate_difficulty?
    self.difficulty = calculate_difficulty
    save
  end

  def self.options_for_sorted_by
    [
        ['Title (a-z)', 'title_asc'],
        ['Tag (a-z)', 'tag_name_asc']
    ]
  end

  def self.options_for_graphic
    [["True", true], ["False", false]]
  end

  def self.options_for_pool
    [["Exam Pool", true], ["MCQ Pool", false]]
  end

  def self.options_for_publish
    [["Published", 0], ["Not Published", 1]]
  end


  def self.options_for_new_pool
    [["Exam", 1], ["Exercise", 0], ["Tutor-Use", 2] ]
  end

  def self.options_for_work_status
    [["Not Started", 0], ["Initial Writing", 1], ["Ready for Review 1", 2], ["Rewrites per First Review", 3], ["Discard", 4], ["Ready for Review 2", 5], ["(no longer in use) Review 2 Complete", 6], ["Ready for Graphics Designer", 7], ["Graphics Supplied", 8], ["Graphics Update Needed", 9], ["(no longer in use) Graphics Complete", 10],["Ready for Video Explainer", 11],["Ready for VER", 12],["Video Updated Needed", 13], ["Formatting Complete & Published", 14]]
  end

  def self.options_for_rating
    [["10 or less", 10], ["9 or less", 9], ["8 or less", 8], ["7 or less", 7], ["6 or less", 6], ["5 or less", 5], ["4 or less", 4], ["3 or less", 3], ["2 or less", 2], ["1 or less", 1]]
  end

  def self.options_for_appear_in_exam
    [["Yes", true], ["No", false]]
  end

  def self.with_tag(tag_id)
    joins(:taggings).where('taggings.tag_id IN (?)', Tag.find(tag_id).self_and_descendants_ids)
  end

  def self.options_for_min
    (0..100)
  end

  def self.options_for_max
    (0..100)
  end


  def self.with_tags(tag_ids)
    joins(:taggings).where('taggings.tag_id IN (?)', tag_ids)
  end

  def difficulty=(difficulty)
    self.autogenerate_difficulty = (difficulty == 'auto')
    if self.autogenerate_difficulty
      super calculate_difficulty
    else
      super difficulty
    end
  end

  def validate_can_publish
    errors.add(:published, "Mcq_Stem can only be pubilshed once reviewed") if (published? && !reviewed?)
  end
  #
  # def self.with_difficulty level
  #   return nil  if level.blank?
  #   McqStem.all.select { |mcq_stem|
  #     mcq_stem.difficulty.between?(McqStem::DIFFICULTY_LEVELS[level.to_sym][:bottom], McqStem::DIFFICULTY_LEVELS[level.to_sym][:top]) if mcq_stem.difficulty
  #   }
  # end

  # def update_mcqs_tag
  #   self.mcqs.each { |mcq|
  #     mcq.update_columns :tag_id => self.tag_id
  #   }
  # end

  def to_s
    title
  end

  def name_human
    "Mcq Stem"
  end

  def mcq_tags
    tags = []
    mcqs.includes(:tag).each do |mcq|
      tags << mcq.tag
    end
    return tags.uniq
  end

  def set_published
    if status == 'published'
      self.published = true
    else
      self.published = false
    end
    if pool == "exam"
      self.examinable = true
    else
      self.examinable = false
    end
  end

  private

  def validate_lock_exam
    return if section_items.blank? && !examinable
    return if !(examinable_changed? || published_changed?)
    locked = false
    sections = Section.includes(:sectionable).where(id: section_items.pluck(:section_id).uniq)
    sections.each do |section|
      locked = true if section.sectionable.locked
    end
    if locked
      type = sections.first.sectionable_type == 'OnlineExam' ? 'Exam' : 'Diagnostic Test'
      errors.add(:examinable, "Cannot edit MCQ Stem since the MCQ is part of an locked #{type}. Please contact support team if any updates required.") if examinable_changed?
      errors.add(:published, "Cannot edit MCQ Stem since the MCQ is part of an locked #{type}. Please contact support team if any updates required.") if published_changed?
    end
  end
end