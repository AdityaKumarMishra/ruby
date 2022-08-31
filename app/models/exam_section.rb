# == Schema Information
#
# Table name: exam_sections
#
#  id              :integer          not null, primary key
#  title           :string
#  dificultyRating :float
#  exam_id         :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  slug            :string
#

class ExamSection < ApplicationRecord
  extend FriendlyId

  belongs_to :exam, optional: true
  has_many :mcqs, -> {default_order}, dependent: :nullify

  accepts_nested_attributes_for :mcqs, :allow_destroy => true

  friendly_id :title, use: :slugged

  validates_presence_of :title, :dificultyRating
  validates_uniqueness_of :title

  scope :without_exams, -> { where(exam_id: nil) }
end
