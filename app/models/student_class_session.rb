# == Schema Information
#
# Table name: student_class_sessions
#
#  id               :integer          not null, primary key
#  start_time       :datetime
#  end_time         :datetime
#  frequency        :integer
#  student_class_id :integer
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

class StudentClassSession < ApplicationRecord
  include EventableItem

  belongs_to :student_class

  validates :start_time, presence: true
  validates :end_time, presence: true
  validates :student_class_id, presence: true

  def item_coverd
    student_class.item_coverd if student_class
  end

  def self.for_tutor user
    student_class_ids = StudentClass.for_tutor(user).collect { |student_class|
      student_class.id
    }.uniq
    self.retrieve_sessions_for_event student_class_ids
  end

  def self.for_student user
    student_class_ids = StudentClass.for_student(user).collect { |student_class|
      student_class.id
    }.uniq
    self.retrieve_sessions_for_event student_class_ids
  end

  def retrieve_events
    events = []
    if student_class.tutors.any? && student_class.students.any?
      events << to_event(student_class.tutors.map(&:to_s).join(', '),  student_class.students.map(&:to_s).join(', '))
    end
    events
  end

  private

  def to_event tutor, student
    EventItem.new(
        :name => 'Exam',
        :tutor => tutor,
        :student => student,
        :time_start => start_time,
        :time_end => end_time,
        :type => self.class.name,
        :id => id
    )
  end

  def self.retrieve_sessions_for_event student_class_ids
    result = []
    result = StudentClassSession.where("student_class_id IN (#{student_class_ids.join(',')})") if student_class_ids.any?
    result
  end
end
