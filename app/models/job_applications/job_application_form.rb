# == Schema Information
#
# Table name: job_application_forms
#
#  id                  :integer          not null, primary key
#  title               :string
#  description         :text
#  open                :boolean
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#

class JobApplicationForm < ApplicationRecord
  include FriendlyId
  friendly_id :title
  has_many :job_applications, dependent: :destroy
  has_many :application_questions, dependent: :destroy
  has_one :job_description, dependent: :destroy

  validates :title, :slug, presence: true
  validates_associated :job_description
  validates_inclusion_of :open, in: [true, false], message: 'Please select one'

  accepts_nested_attributes_for :application_questions, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :job_description

  default_scope { order(title: :asc) }

  scope :active_jobs, -> { where('open = ?', true) }
  scope :archived_jobs, -> { where('open = ?', false) }

  scope :with_open, lambda { |option|
    where(open: option)
  }
  friendly_id :title, use: :slugged

  scope :with_title, -> (title){ where "title ILIKE :title", title: "%#{title}%" }

  filterrific(
      available_filters: [
          :with_open,
          :with_title,
      ]
  )

  def to_param
    "#{title.parameterize}" if title
  end

  def self.build_new
    job_application_form = self.new
    job_application_form.build_job_description

    job_application_form
  end

  def validate_attachments
    self.build_job_description if empty_attachment
  end

  def empty_attachment
    self.job_description.nil? || !self.job_description.document.present?
  end

end
