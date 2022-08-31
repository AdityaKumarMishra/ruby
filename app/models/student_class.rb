# == Schema Information
#
# Table name: student_classes
#
#  id                :integer          not null, primary key
#  name              :string
#  size              :integer
#  created_at        :datetime         not null
#  updated_at        :datetime         not null
#  course_version_id :integer
#  active_subject_id :integer
#  item_coverd       :text
#

class StudentClass < ApplicationRecord
  belongs_to :active_subject, :foreign_key => 'active_subject_id', :class_name => 'ActiveSubject'
  has_one :subject, through: :active_subject, dependent: :nullify
  has_and_belongs_to_many :tutors, -> { where(role: 'Tutor') }, :join_table => 'tutors_classes', :class_name => 'User'
  has_and_belongs_to_many :students, -> { where(role: 'Student') }, :join_table => 'students_classes', :class_name => 'User'
  has_many :student_class_sessions, :dependent => :destroy
  belongs_to :course_version, optional: true

  accepts_nested_attributes_for :active_subject
  accepts_nested_attributes_for :subject

  scope :for_tutor, -> (user) { joins(:tutors).where('tutors_classes.user_id' => user.id)}
  scope :for_student, -> (user) { joins(:students).where('students_classes.user_id' => user.id)}

  validates :size, presence: true
  validates :name, presence: true
  
  def tutors_for_subject
    tutor_list = []
    tutors.each { |tutor|
      tutor_list << {:tutor_name => tutor.full_name, :tutor_email => tutor.email, :subject => subject}
    }
    tutor_list
  end

  def availeble_students
    avaleble = User.student.without_course
    avaleble + self.students
  end

  def is_full
    (course_version.class_size <= students.count)
  end

  def to_s
    name
  end

  def tutors_to_s
    tutors.map(&:to_s)
  end

  def students_to_s
    students.map(&:to_s)
  end
end
