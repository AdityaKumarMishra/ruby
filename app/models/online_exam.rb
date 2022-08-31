class OnlineExam < ApplicationRecord
  require 'csv'
  include Positionable

  validates :title, presence: true
  has_many :online_exam_prints
  has_many :tickets, as: :questionable
  has_many :sections, as: :sectionable, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  # has_many :online_mock_exam_online_exams, dependent: :destroy
  has_many :online_mock_exam_sections, dependent: :destroy
  has_many :assessment_attempts, as: :assessable, dependent: :destroy

  accepts_nested_attributes_for :sections

  validate :publishable?

  has_attached_file :document, path: APP_CONFIG[:paperclip_path],
                               url: APP_CONFIG[:paperclip_url]
  validates_attachment_content_type :document, content_type: 'application/pdf'

  filterrific(
      available_filters: [
          :by_product_line,
          :search_by_title
      ]
  )

  scope :search_by_title, lambda {|query|
    return nil if query.blank?
    term = query.to_s.downcase
    term = ('%' + term.tr('*', '%').tr('\'','\\') + '%').gsub(/%+/, '%')
    self.where("title ILIKE ?", term)
  }

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

  # after_create :set_online_exam_position
  # before_save :set_diagnostic_exam_position
  # def set_online_exam_position
  #   if self.position.blank?
  #     if self.title.downcase.include?("diagnostic")
  #       self.position = 0
  #       self.save
  #     else
  #       position = self.title.split(" ").last
  #       if position.to_i.to_s == position
  #         self.position = position.to_i
  #         self.save
  #       end
  #     end
  #   end
  # end

  # def set_diagnostic_exam_position
  #   self.position = 0 if self.title.downcase.include?("diagnostic")
  # end

  def to_s
    title
  end

  def publishable?
  	errors.add(:published, "Can't be published. Atleast One section is required") if published? and sections.count <= 0
  end

  def full_url
    Rails.application.routes.url_helpers.url_for controller: 'online_exams', action: 'download', id: self.id, only_path: true
  end

  def self.to_csv(online_exam)
    # headers = ["Student Name","Email Address", "Section Title", "Total Questions","Raw Score", "Percentile Score"]
    # assessment_attempts = online_exam.assessment_attempts.completed
    # CSV.generate(headers: true) do |csv|
    #   csv << headers
    #   if assessment_attempts.present?
    #     assessment_attempts.each do |assessment_attempt|
    #       assessment_attempt.section_attempts.order(:section_id).each do |sa|
    #         csv << [
    #           assessment_attempt.user.try(:full_name),
    #           assessment_attempt.user.try(:email),
    #           sa.section.try(:title),
    #           sa.total_count,
    #           sa.mark,
    #           sa.percentile.present? ? sa.percentile.round(2) : 0
    #         ].flatten
    #       end
    #     end
    #   end
    # end
    if online_exam.present?
      headers = ["Section Title", "Unit Title", "Total Questions", "Question Number", "Difficulty", "Tags", "% Correct"]
      CSV.generate(headers: true) do |csv|
        csv << headers
        online_exam.sections.order(:id).each do |section|
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
              csv << [
                section.title,
                mcq_stem.title,
                mcq_stem.mcqs.count,
                index + 1,
                diff,
                mcq.tag.name,
                mcq.mcq_answers.find_by(correct: true).fetch_answer_picked_percentage.to_s + "%"
              ]
            end
          end
        end
      end
    end
  end
end
