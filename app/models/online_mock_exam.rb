class OnlineMockExam < ApplicationRecord
  require 'csv'
  include OnlineMockExamsHelper
  has_many :online_mock_documents, dependent: :destroy
  has_one :online_mock_vod, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  belongs_to :user, optional: true
  has_many :assessment_attempts, as: :assessable, dependent: :destroy
  # has_many :essays
  accepts_nested_attributes_for :online_mock_documents, :online_mock_vod, allow_destroy: true
  validates :title, :city, presence: true
  #validates :city, uniqueness: true
  has_many :online_mock_exam_sections, dependent: :destroy
  accepts_nested_attributes_for :online_mock_exam_sections,allow_destroy: true

  filterrific(
      available_filters: [
          :by_product_line,
          :search_by_title_mock
      ]
  )

  scope :search_by_title_mock, lambda {|query|
    return nil if query.blank?
    term = query.to_s.downcase
    term = ('%' + term.tr('*', '%').tr('\'','\\') + '%').gsub(/%+/, '%')
    self.where("title ILIKE ?", term)
  }

  GAMSAT_SECTION = ['Section I: Reasoning in Humanities and Social Sciences','Section II: Written Communication', 'Section III: Reasoning in Biological and Physical Sciences'].freeze

  enum city: [ "Melbourne", "Sydney", "Brisbane", "Adelaide", "Perth", "Canberra",
               "Sept-GAMSAT Melbourne", "Sept-GAMSAT Sydney", "Sept-GAMSAT Brisbane",
               "Sept-GAMSAT Adelaide", "Sept-GAMSAT Perth", "Other"
             ]

  scope :by_product_line, -> (type) {
    if type == "Gamsat"
      joins(:tags).where(tags: { id: Tag.find(246).self_and_descendants_ids })
    elsif type == "Umat"
      joins(:tags).where(tags: { id: Tag.find(30).self_and_descendants_ids })
    elsif type == "Vce"
      joins(:tags).where(tags: { id: Tag.find(325).self_and_descendants_ids + Tag.find(37).self_and_descendants_ids })
    elsif type == "Hsc"
      joins(:tags).where(tags: { id: Tag.find(326).self_and_descendants_ids + Tag.find(38).self_and_descendants_ids })
    end

  }

  def to_s
    title
  end

  def nearest_date_document_start
    nearest_date_doc = self.online_mock_exam_sections.order(start_date: :asc, start_time: :asc).first
    start_date = nearest_date_doc.try(:start_date).to_s
    start_time = nearest_date_doc.try(:start_time).strftime("%H:%M%P")
    return comparable_start_time = city_time(start_date, start_time)
  end

  def latest_date_document_end
    latest_date_doc = self.online_mock_exam_sections.order(end_date: :asc, end_time: :asc).last
    end_date = latest_date_doc.try(:end_date).to_s
    end_time = latest_date_doc.try(:end_time).strftime("%H:%M%P")
    return comparable_end_time = city_time(end_date, end_time)
  end

  def yet_to_start?
    nearest_date_document_start > city_time_now
  end

  def already_finished?
    latest_date_document_end < city_time_now
  end

  def valid_mock_exam
    (nearest_date_document_start >= city_time_now || latest_date_document_end <= city_time_now) ? true : false
  end

  def valid_attempt_to_create?
    return (nearest_date_document_start > city_time_now && latest_date_document_end > city_time_now) || (nearest_date_document_start <= city_time_now && latest_date_document_end >= city_time_now)
  end

  def show_countdown?
    self.try(:valid_mock_exam)
  end

  def is_published?
    self.published
  end


  def self.to_csv(online_mock_exam)
    # headers = ["Student Name","Email Address", "Section Title", "Total Questions","Raw Score", "Percentile Score"]
    # assessment_attempts = online_mock_exam.assessment_attempts.completed
    # CSV.generate(headers: true) do |csv|
    #   csv << headers
    #   if assessment_attempts.present?
    #     assessment_attempts.each do |assessment_attempt|
    #       assessment_attempt.section_attempts.order(:section_id).each do |sa|
    #         csv << [
    #           assessment_attempt.user.try(:full_name),
    #           assessment_attempt.user.try(:email),
    #           sa.section.try(:title),
    #           sa.try(:section).try(:mcqs).try(:count),
    #           sa.mark,
    #           sa.percentile.present? ? sa.percentile.round(2) : 0
    #         ].flatten
    #       end
    #     end
    #   end
    # end
    if online_mock_exam.present?
      headers = ["Section Title", "Unit Title", "Total Questions", "Question Number", "Difficulty", "Tags", "% Correct"]
      CSV.generate(headers: true) do |csv|
        csv << headers
        section_ids = SectionAttempt.joins(:assessment_attempt).where("assessment_attempts.assessable_type = 'OnlineMockExam' AND  assessable_id =? ",online_mock_exam.id).pluck(:section_id).uniq
        if online_mock_exam.per_city_exam_count <= 1
          section_ids = section_ids - [148, 150]
        else
          section_ids = section_ids - [169, 170]
        end
        sections = Section.where(id: section_ids).order(:sectionable_id)
        if online_mock_exam.assessment_attempts.completed.present?
          if sections.present?
            sections.each do |section|
              section.mcq_stems.uniq.each do |mcq_stem|
                mcq_stem.mcqs.order(:id).each_with_index do |mcq, index|
                  diff = ''
                  if mcq.difficulty.to_i > 0 && mcq.difficulty.to_i <= 33
                    diff = "Easy"
                  elsif mcq.difficulty.to_i > 33 && mcq.difficulty.to_i <= 66
                    diff = "Medium"
                  else
                    diff = "Hard"
                  end
                  percent_csv = mcq.mcq_answers.find_by(correct: true).fetch_answer_picked_percentage.to_s + "%" rescue ''
                  csv << [
                    section.title,
                    mcq_stem.title,
                    mcq_stem.mcqs.count,
                    index + 1,
                    diff,
                    mcq.tag.name,
                    percent_csv
                  ]
                end
              end
            end
          end
        end
      end
    end
  end

end
