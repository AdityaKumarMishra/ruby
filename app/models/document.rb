# == Schema Information
#
# Table name: documents
#
#  id                       :integer
#  accessible               :boolean
#  allow_dummy              :datetime
#  only_dummy               :datetime
#  user_id                  :integer
#  attachment_file_name     :string
#  attachment_content_type  :string
#  attachment_file_size     :integer
#  attachment_updated_at    :datetime
#  created_at               :datetime
#  updated_at               :datetime
#

class Document < ApplicationRecord
  belongs_to :user, optional: true
  belongs_to :product_line

  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  has_many :access_documents, dependent: :destroy
  has_many :users, through: :access_documents
  has_many :tickets, as: :questionable

  has_attached_file :attachment, :restricted_characters => /[&$+,\/:;=?@<>\[\]\{\}\|\\\^~%]/

  validates_attachment_presence :attachment, message: 'Please include a document'
  validates_attachment_content_type :attachment, content_type: [ 'image/jpeg', 'application/pdf', 'application/msword', 'application/vnd.openxmlformats-officedocument.wordprocessingml.document'], message: 'Invalid file type'

  validates :product_line_id, presence: true, if: Proc.new { |document| document.for_timetable }
  validates :product_line_id, presence: true, uniqueness: true, if: Proc.new { |document| document.for_timetable }

  after_save :validate_dummy

  filterrific(
      available_filters: [
          :with_title,
          :with_tag,
          :sorted_by,
          :by_product_line
      ]
  )


  scope :by_product_line, -> (product_line) {
    tag_ids = Tag.level_one.where('name like ?', "%#{product_line.upcase}%").map(&:self_and_descendants_ids).flatten
    joins(:tags).where(tags: { id: tag_ids })}


  scope :with_tag, lambda { |tag_id| with_tag(tag_id) }

  scope :with_title, lambda { |query|
    return nil if query.blank?
    term = query.to_s.downcase
    term = ('%' + term.tr('*', '%') + '%').gsub(/%+/, '%')
    where('(LOWER(documents.attachment_file_name) LIKE ?)', term)
  }

  scope :sorted_by, lambda { |sort_option|
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^created_at_/
        order("documents.created_at #{direction}")
      when /^title_/
        order(attachment_file_name: direction)
      when /^tag_name_/
        order(:tags)
      else
        fail(ArgumentError, "Invalid sort option: #{sort_option.inspect}")
    end
  }

  def self.with_tag(tag_id)
    joins(:taggings).where('taggings.tag_id IN (?)', Tag.find(tag_id).self_and_descendants_ids)
  end

  def validate_dummy
    if self.only_dummy
      self.update_column('allow_dummy', true)
    end
  end

  def self.options_for_sorted_by
    [
        ['Title (a-z)', 'title_asc'],
        ['Newest First', 'created_at_desc'],
        ['Oldest First', 'created_at_asc'],
        ['Title (z-a)', 'title_desc']
    ]
  end

  def set_last_accessed(user)
    access_document = AccessDocument.find_by(document: self)
    access_document = self.access_documents.create(document: self, user: user) unless access_document
    access_document.set_last_accessed
  end

  def name_human
    "Document"
  end

  def title
    attachment_file_name.titleize
  end
end
