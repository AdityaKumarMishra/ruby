# == Schema Information
#
# Table name: textbooks
#
#  id                    :integer          not null, primary key
#  title                 :string
#  document_file_name    :string
#  document_content_type :string
#  document_file_size    :integer
#  document_updated_at   :datetime
#  created_at            :datetime         not null
#  updated_at            :datetime         not null
#

class Textbook < ApplicationRecord

  attr_accessor :encrypted

  belongs_to :user

  has_many :textbook_urls
  has_many :textbook_prints
  has_many :tickets, as: :questionable
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  belongs_to :course, optional: true
  has_many :completed_textbooks, dependent: :destroy
  has_many :performance_stats, as: :performable
  has_many :user_stats, as: :viewable
  has_many :out_of_stocks, dependent: :destroy
  has_many :textbook_reads
  #validates_presence_of :title,:document

  has_attached_file :document, path: APP_CONFIG[:paperclip_path],
                               url: APP_CONFIG[:paperclip_url]
  validates_attachment_content_type :document, content_type: 'application/pdf'

  filterrific(
    available_filters: [
      :with_tags,
      :with_title,
      :sorted_by,
      :by_product_line
    ]
  )

  scope :by_product_line, -> (product_line) {
    @@product_lines= product_line
    tag_ids = Tag.level_one.where('name like ?', "%#{product_line.upcase}%").map(&:self_and_descendants_ids).flatten
    joins(:tags).where(tags: { id: tag_ids })}

  scope :to_reset, -> { Textbook.where.not(for_document: true, for_live_slide: true, for_textbook: true)}

  scope :by_type, -> (type, current_user) {
    if type == "textbook_slides"
      where(for_textbook_slide: true)

    elsif type == "attendance_course_resources"
      where(for_live_handout: true)

    elsif type == "attendance_course_slides"
      where(for_live_slide: true)

    elsif type == "supplementary_resources" && current_user.student?
      where('for_document =? AND for_timetable != ?', true , true)

    elsif type == "supplementary_resources" && !current_user.student?
      where(for_document: true)

    elsif type == "textbook_chapters"
      where(for_textbook: true)

    elsif type == "downloadable_resources"
      where(for_downloadable_resource: true)

    elsif type == "weekend_course_slides"
      where(for_weekend: true)

    elsif type == "additional_chapters"
      where(for_additional_chapter: true)

    elsif type == 'revision_weekend'
      where(for_revision_weekend: true)

    elsif type == 'mock_exam'
      where(for_mock_exam: true)
    end
  }

  before_create :add_live_class_timetable_to_textbook_name
  after_create :course_create_tag_for_textbook

  def add_live_class_timetable_to_textbook_name
    if self.document_file_name.present?
      self.title = self.document_file_name.titleize.split(".").first if course.present?
    end
  end

  def course_create_tag_for_textbook
    if course.present?
      if course.product_version.type == "GamsatReady"
        self.taggings.create(tag_id: 246)
      elsif course.product_version.type == "UmatReady"
        self.taggings.create(tag_id: 30)
      end
    end
  end

  scope :product_line_collection, -> {
    product_line_ids = Textbook.where.not(product_line_id: nil).pluck(:product_line_id)
    ProductLine.all.where.not(id: product_line_ids).order(:name).map {|product_line| [product_line.name.try(:upcase), product_line.id]}
  }

  scope :with_tags, -> (tag_id) { 
    if tag_id != 'All'
      joins(:tags).where(tags: { id: Tag.find(tag_id).self_and_descendants_ids }) 
    elsif tag_id== 'All'
      tag_ids = Tag.level_one.where('name like ?', "%#{@@product_lines.upcase}%").map(&:self_and_descendants_ids).flatten
      joins(:tags).where(tags: { id: tag_ids }) 
    end
  }
  scope :by_tags, -> (tag_id) { includes(:taggings).where(taggings: { tag_id: tag_id }) }
  scope :with_title, lambda { |query|
    return nil if query.blank?
    term = query.to_s.downcase
    term = ('%' + term.tr('*', '%') + '%').gsub(/%+/, '%')
    where('(LOWER(textbooks.title) LIKE ?)', term)
  }
  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^created_at_/
        order("textbooks.created_at #{direction}")
      when /^title_/
        order(title: direction)
      else
        fail(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  def name_human
    "Textbook"
  end

  def self.options_for_sorted_by
    [
        ['Title (a-z)', 'title_asc'],
        ['Newest First', 'created_at_desc'],
        ['Oldest First', 'created_at_asc'],
        ['Title (z-a)', 'title_desc']
    ]
  end


  def selected_textbook_type
    if for_textbook
      'Supplementary Resources (All paying and non-paying students) DL - No'
    elsif for_textbook_slide
      'Textbook Slides (Online or Hardcopy TB) DL - No'
    elsif for_live_handout
      'PBL Additional Resources (PBLs) DL - Yes'
    elsif for_live_slide
      'PBL In-Class Slides (PBLs) DL - No'
    elsif for_document
      'Supplementary Resources (All paying and non-paying students) DL - No'
    elsif for_downloadable_resource
      'Downloadable Resources (All paying and non-paying students) DL - Yes'
    elsif for_revision_weekend
      'Revision Weekend (Revision Weekend) DL - No'
    elsif  for_mock_exam
      "Mock Exam (Online Exams) DL - No"
    end
  end

end
