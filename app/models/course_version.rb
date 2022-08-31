# == Schema Information
#
# Table name: course_versions
#
#  id                  :integer          not null, primary key
#  version_number      :integer
#  date_added          :datetime
#  class_size          :integer
#  expiry_date         :date
#  enrolment_end_added :datetime
#  students_count      :integer
#  course_id           :integer
#  created_at          :datetime         not null
#  updated_at          :datetime         not null
#  start_date          :datetime
#  end_date            :datetime
#  is_user_version     :boolean
#  course_address_id   :integer
#

class CourseVersion < ApplicationRecord
  belongs_to :course
  belongs_to :address, :foreign_key => 'course_address_id'
  has_and_belongs_to_many :users, :join_table => 'students_course_versions'
  has_many :active_subjects, :class_name => 'ActiveSubject', dependent: :destroy
  has_many :subjects, through: :active_subjects
  has_many :student_classes, dependent: :destroy

  accepts_nested_attributes_for :address

  scope :active, -> {joins(:course).where('courses.is_active' => true)}

  validates_presence_of :version_number
  validates_presence_of :date_added
  validates_presence_of :class_size
  validates_presence_of :expiry_date
  validates_presence_of :enrolment_end_added
  validates_presence_of :students_count

  after_create :create_default_class

  def sessions
    sessions = []
      student_classes.each { |student_class|
        sessions = sessions + student_class.student_class_sessions
      }
    sessions
  end

  def sign_in user
    unless user.student?
      return {:status => false, :msg => 'You are not a student'}
    end

    if user.is_enrolled_in_course
      return {:status => false, :msg => 'You are already participating in course'}
    else
      self.transaction do
        self.users << user
        self.save!(:validate => false)
        student_class = student_classes.last
        if !student_class || student_class.is_full
          student_class = create_new_student_class
        end
        student_class.students << user
        student_class.save!
        return {:status => true, :msg => "Thank you for joining course #{course.title}:#{version_number}"}
      end
      return {:status => false, :msg => 'There was an error'}
    end
  end

  def sign_out user
    self.transaction do
      student_classes.each { |student_class|
        student_class.students.delete(user) if student_class.students.include? user
      }
      self.users.delete(user) if self.users.include? user
      return true
    end
    return false
  end

  def tutors_with_subjects
    result = []
    subjects.each { |subject|
      subject.student_classes.each { |student_class|
        result = result + student_class.tutors_for_subject
      }
    }
    result
  end

  def title
    "#{course.title} #{version_number}" if course
  end

  def description
    course.description if course
  end

  def to_s
    title
  end

  private

  def create_new_student_class
    class_num = self.student_classes.count + 1
    student_class = StudentClass.create!(
        :name => "#{self.course.title}:#{self.version_number}:#{class_num}",
        :size => self.class_size,
        :active_subject => self.active_subjects.first,
        :course_version_id => self.id
    )
    student_class
  end

  def create_default_class
    student_class = create_new_student_class
    # if self.active_subjects.any?
    #   student_class.update_columns :active_subject => self.active_subjects.first
    # end
  end

end
