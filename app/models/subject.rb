# == Schema Information
#
# Table name: subjects
#
#  id          :integer          not null, primary key
#  title       :string
#  description :text
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  slug        :string
#  course_id   :integer
#

class Subject < ApplicationRecord
  include EditorParsable
  extend FriendlyId

  belongs_to :course_version, optional: true
  belongs_to :course

  has_many :active_subjects, dependent: :destroy
  has_many :student_classes, through: :active_subjects
  has_many :user_subjects, :through => :active_subjects, dependent: :destroy
  has_many :users, through: :user_subjects

  has_one :exam, dependent: :nullify
  has_one :stem_student, dependent: :nullify
  has_many :student_questions, dependent: :destroy
  has_many :tags, dependent: :nullify

  has_many :subject_mcq_stems, dependent: :destroy
  has_many :mcq_stems, through: :subject_mcq_stems, dependent: :nullify
  has_many :mcqs, through: :mcq_stems

  friendly_id :slug_candidates, use: :slugged

  scope :prototypes, -> { where.not(course_id: nil) }
  scope :not_prototypes, -> { where(course_id: nil) }
  scope :default_order, -> {order('title DESC')}
  scope :with_course_by_title, -> { where.not(course_id: nil).group_by{|subject| subject.course.title} }

  validates :slug, presence: true, uniqueness: true
  validates :title, presence: true, length: { maximum: 100 }
  validates :description, presence: true, length: { maximum: 500 }

  def slug_candidates
    [[:course_id, :title]]
  end

  def tutors
    active_subjects.tutors
  end

  def to_s
    title
  end

  def is_prototype
    !course_id.nil?
  end
  alias_method :is_prototype?, :is_prototype

  def self.options_for_filter_select
    with_course_by_title
  end

  def self.options_for_stem_students
    Subject.all
  end

  def self.book_tutor course
    where(course: course).map{ |e| [e.to_s, e.id] }
  end
end
