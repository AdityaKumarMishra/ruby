class MockExamEssay < ApplicationRecord
  attr_accessor :section_type
  belongs_to :user, optional: true
  belongs_to :course,optional: true
  belongs_to :live_exam, optional: true
  has_many :mock_essays, dependent: :destroy
  accepts_nested_attributes_for :mock_essays, allow_destroy: true

  enum status: [:not_submitted, :submitted, :marked, :partially_marked]

  filterrific(
    available_filters: [
      :with_start,
      :with_end,
      :mark_with_start,
      :mark_with_end,
      :by_student,
      :by_course,
      :by_staff,
      :marked_tutor,
      :with_status,
      :course_status
    ]
  )

  scope :by_student, ->(user_id){
    where(user_id: user_id)
  }
  # scope :by_student, -> (name){ includes(:user).where("first_name ILIKE :name OR last_name ILIKE :name OR first_name ||' '|| last_name ILIKE :name OR last_name ||' '|| first_name ILIKE :name OR username ILIKE :name OR email ILIKE :name OR username ||' '|| email ILIKE :name OR email ||' '|| username ILIKE :name"), name: "%#{name}%" }

  scope :with_start, -> (start_date){
    where('mock_exam_essays.submitted_at >= ?', start_date.to_date.beginning_of_day)
  }
  scope :marked_tutor, -> (tutor_id){
    includes(mock_essays: :mock_essay_feedback).where(mock_essay_feedbacks: {user_id: tutor_id})
  }
  scope :with_end, -> (end_date){
    where('mock_exam_essays.submitted_at <= ?', end_date.to_date.end_of_day)
  }
  scope :mark_with_start, -> (start_date){
    where('mock_exam_essays.marked_at >= ?', start_date.to_date.beginning_of_day)
  }
  scope :mark_with_end, -> (end_date){
    where('mock_exam_essays.marked_at <= ?', end_date.to_date.beginning_of_day)
  }
  scope :with_status, ->(status) {
    where(status: status)
  }
  scope :by_staff, ->(staff_id) {
    where("#{staff_id} = ANY (mock_exam_essays.assigned_tutors)")
  }
  scope :by_course, -> (course_name) {
    joins(:course).where("courses.name = ? ", course_name).references(:courses)
  }
  scope :course_status, ->(status){
    if status == 'Current'
      includes(:course).where('courses.expiry_date > ? OR courses.show_archived = ?', Time.zone.now.beginning_of_day, true).references(:courses)
    elsif status == 'Archived'
      includes(:course).where('courses.expiry_date < ? AND courses.show_archived = ?', Date.today, false).references(:courses)
    end
  }

  def average_rating
    rating = 0
    mock_essays.each do |e|
      rating = rating + e.mock_essay_feedback.rating if e.mock_essay_feedback
    end
    rating = (rating/200) * 100
  end

  def submitted_tutor
    User.where(id: assigned_tutors).first.full_name
    #User.where(id: assigned_tutors.pluck(:id)).first.full_name
  end

  def self.partial_feedback_reminder
    if Rails.env.production?
      MockExamEssay.all.each do |mock_exam_essay|
        feedbacks = mock_exam_essay.mock_essays.map{|m| m.mock_essay_feedback}.compact
        if feedbacks.count == 1
          if (feedbacks.first.created_at < Time.zone.now - 3.days)
            MockExamEssayMailer.partial_feeback_mail(mock_exam_essay).deliver_later  if ENV['EMAIL_CONFIRMABLE'] != "false"
          end
        end
      end
    end
  end

  def self.overdue_reminder
    if Rails.env.production?
      # New Code for GRAD-3135
      mock_exam_essays = MockExamEssay.where("DATE(created_at) = ?", (Date.today) - 8.days)
      mock_exam_essays.with_status([1,3]).each do |mock_exam_essay|
        MockExamEssayMailer.send_overdue_reminder(mock_exam_essay).deliver_later  if ENV['EMAIL_CONFIRMABLE'] != "false"
      end

      # Comment OLD Code for task GRAD-3135
      # if CommonContent.first.present? && (CommonContent.first.mock_exam_overdue == Date.today)
      #   MockExamEssay.with_status([1,3]).each do |mock_exam_essay|
      #     MockExamEssayMailer.send_overdue_reminder(mock_exam_essay).deliver_later  if ENV['EMAIL_CONFIRMABLE'] != "false"
      #   end
      # end
    end
  end

end
