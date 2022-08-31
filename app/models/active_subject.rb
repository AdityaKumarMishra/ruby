# == Schema Information
#
# Table name: active_subjects
#
#  id                :integer          not null, primary key
#  subject_id        :integer
#  course_version_id :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#

class ActiveSubject < ApplicationRecord
  belongs_to :subject
  belongs_to :course_version, optional: true
  has_many :student_classes, dependent: :nullify, :foreign_key => 'active_subject_id'

  has_many :user_subjects, dependent: :destroy
  has_many :users, through: :user_subjects
  has_and_belongs_to_many :tutors, -> { where(role: 'Tutor') }, :join_table => 'user_subjects', :class_name => 'User'
  has_and_belongs_to_many :students, -> { where(role: 'Student') }, :join_table => 'user_subjects', :class_name => 'User'

  scope :with_course_version_by_title, -> { where.not(course_version_id: nil).group_by{|subject| subject.course_version.title} }

  def title
    subject.title
  end

  def description
    subject.description
  end

  def to_s
    subject.to_s
  end
end
