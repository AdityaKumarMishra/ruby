# == Schema Information
# t.text     "response"
# t.time     "time_submited"
# t.integer  "user_id"
# t.datetime "created_at",      null: false
# t.datetime "updated_at",      null: false
# t.integer  "essay_id"
# t.string   "slug"
# t.date     "activation_date"
# t.date     "expiry_date"
# t.integer  "elapsed_time",    default: 0
# t.integer  "status",          default: 0

class EssayResponse < ApplicationRecord
  include EditorParsable
  extend FriendlyId

  belongs_to :user
  belongs_to :essay
  belongs_to :course, optional: true
  belongs_to :tutor, class_name: 'User', optional: true
  belongs_to :assessment_attempt, optional: true
  has_one :essay_tutor_response, :class_name => 'EssayTutorResponse', dependent: :destroy
  has_one :essay_tutor_feedback, :class_name => 'EssayTutorFeedback', dependent: :destroy
  has_many :tickets, as: :questionable
  validates :expiry_date, presence: true

  enum status: [:unanswered, :unmarked, :marked, :has_feedback]
  friendly_id :slug_candidates, use: :slugged

  after_create :update_tutor

  filterrific(
      available_filters: [
          :search_query_title,
          :with_status,
          :search_query_student,
          :by_staff,
          :by_current_user,
          :by_course,
          :with_start,
          :with_end,
          :submitted_start_date,
          :submitted_with_end,
          :to_submitter,
          :course_status
      ]
  )

  scope :with_tag, -> (tag_ids) {
    includes(essay: :taggings).where(taggings: { tag_id: tag_ids })
     }

  scope :with_start, lambda {|start_date|
    self.includes(:essay_tutor_response).where('essay_tutor_responses.created_at >= ?', start_date.to_date.beginning_of_day).references(:essay_tutor_responses)
  }

  scope :with_end, lambda {|end_date|
    self.includes(:essay_tutor_response).where('essay_tutor_responses.created_at <= ?', end_date.to_date.end_of_day).references(:essay_tutor_responses)
  }

  scope :submitted_start_date, ->(start_date) {
    where('essay_responses.time_submited >= ?', start_date.to_date.beginning_of_day)
  }
  scope :submitted_with_end, ->(end_date) {
    where('essay_responses.time_submited <= ?', end_date.to_date.end_of_day)
  }

  scope :to_submitter, -> (tutor_id){
    where(tutor_id: tutor_id)
  }

  scope :by_current_user, lambda { |user_id|
    current_user = User.find(user_id)
    responses = self#.where.not(status: 0)
    if current_user.present? && current_user.tutor?
      responses.where(tutor_id: user_id)
    end
    responses.includes(:essay)
  }

  scope :with_year_and_month, ->(year, month) {
    where(expiry_date: Date.new(year,month,1)..Date.new(year,month,-1))
  }

  scope :search_query_title, lambda { |query|
    return nil if query.blank?
    term = query.to_s.downcase
    term = ('%' + term.tr('*', '%').tr('\'','\\') + '%').gsub(/%+/, '%')
    self.includes(:essay).where("essays.title ILIKE ?", term).references(:essays)
  }

  scope :search_query_student, lambda {|query|
    return nil if query.blank?
    term = query.to_s.downcase
    term = ('%' + term.tr('*', '%').tr('\'','\\') + '%').gsub(/%+/, '%')
    self.includes(:user).where("((users.first_name ILIKE ?) OR (users.last_name ILIKE ?) OR (users.username ILIKE ?)) AND (role = ?)", term,term,term,0).references(:users)
  }

  scope :by_staff, lambda {|staff_id|
    return nil if staff_id.blank?
    self.includes(essay_tutor_response: :staff_profile).where(staff_profiles: {staff_id: staff_id})
  }

  scope :with_status, ->(status) {
    if status == "Unmarked"
                                      where(status: 1)
                                    elsif status == "Marked"
                                      where(status: 2..3)
                                    elsif status == "Has feedback"
                                      where(status: 3)
                                    elsif status == 'Unsubmitted'
                                      where('essay_responses.status = (?) AND essay_responses.expiry_date >= ?', 0, Date.today)
                                    elsif status == 'Expired'
                                      where('essay_responses.status = (?) AND essay_responses.expiry_date < ?', 0, Date.today)
                                    end
  }
  scope :course_status, ->(status){
    if status == 'Current'
      self.includes(:course).where('courses.expiry_date > ? OR courses.show_archived = ?', Time.zone.now.beginning_of_day, true).references(:courses)
    elsif status == 'Archived'
      self.includes(:course).where('courses.expiry_date < ? AND courses.show_archived = ?', Date.today, false).references(:courses)
    end
  }

  scope :by_course, lambda {|course_name|
    return nil if course_name.blank?

    self.includes(:course).where("courses.name = ? ", course_name).references(:courses)
  }

  def self.pay_periods
    initial_start_date = Date.parse("03/08/2016")
    pay_base = pay_period_base(initial_start_date)
    pay_periods = []
    pay_period_end = (Time.zone.today - Date.parse("03/08/2016")).to_i / 14
    # The number of pay periods between between today and 03/08/2016
    pay_period_start = [0, pay_period_end - 40].max
    # Ensuring only the latest 40 pay periods are being displayed to help future proof the code base
    (pay_period_start..pay_period_end).each do |i|
      pay_periods.push(["#{pay_base[0] + (i * 14)} - #{pay_base[1] + (i * 14)}"])
    end
    pay_periods.reverse
  end

  def self.pay_period_base(initial_start_date)
    diff = (Time.zone.today - initial_start_date) % 14
    p1_start = initial_start_date + (diff * 14)
    p1_end = p1_start + 13
    [p1_start, p1_end]
  end

  def answered_responses(current_user=nil)
    responses = where.not(status: 0)
    if current_user.present? && current_user.tutor?
      responses = tutor_essays(responses, current_user)
    end
    return responses
  end

  def short_response
    self.response.truncate(50, omission: '...')
  end

  def slug_candidates
    [
      [(user.username.to_s + ' ' + self.essay.title).truncate(25), rand(1000..100_000)]
    ]
  end
  def inform_tutor(emails = [])
    EssayResponseMailer.unmarked_essay(self, emails).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
  end

  def is_active
    return @false if (activation_date.nil? || expiry_date.nil?)
    if activation_date<=Date.today && Date.today <=expiry_date
      return true
    else
      return false
    end
  end

  def tags
    []
  end

  def staff_profile
    if essay_tutor_response
      essay_tutor_response.staff_profile
    else
      nil
    end

  end

  def ticket_content_url
    essay
  end

  def self.tutor_essays(current_responses, current_user)

    allowed_responses = []
    course_array=[]

    current_responses.each do |essay_response|

      course_array=[]
      essay_response.user.paid_enrolments.select{|e| course_array.push(e.course)}
      allowed_responses.push(essay_response) if (current_user.staff_profile.courses & (course_array)).present?
    end
    return allowed_responses
  end

  def name_human
    user.full_name
  end

  def tags
    return essay.tags
  end

  def title
    essay.title
  end

  def self.marked_responses(current_user=nil)
    # Essays that are already marked
    current_user.validate_staff_profile
    if current_user.moderator?
      responses = EssayResponse.includes(:essay_tutor_response, :essay).where('essay_tutor_responses.staff_profile_id IS NOT ?', nil).references(:essay_tutor_responses)
    else
      responses = EssayResponse.includes(:essay_tutor_response, :essay).where('essay_tutor_responses.staff_profile_id = ?', current_user.staff_profile).references(:essay_tutor_responses)
    end
    return responses
  end

  def self.unmarked_responses(current_user=nil)
    # Essays where are not marked
    responses = EssayResponse.includes(:essay).where('time_submited is not ?', nil).order("essays.title").select{ |s|  s.essay_tutor_response.nil? }
    if current_user.present? && current_user.tutor?
      responses=tutor_essays(responses, current_user)
    end
    return responses
  end

  def self.essay_unmarked_reminder
    EssayResponse.where("status = ? AND time_submited < ?", EssayResponse.statuses["unmarked"], (Time.zone.now - 3.days)).find_each do |er|
      EssayResponseMailer.essay_reminder(er).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
    end
  end

  def self.test_essay_unmarked_reminder
    #EssayResponseMailer.test_essay_reminder.deliver_now if ENV['EMAIL_CONFIRMABLE'] != "false"
    puts Time.zone.now
    Rails.logger.info Time.zone.now
  end

  def self.send_expiry_reminder
    if Rails.env.production?
      EssayResponse.all.each do |essay_response|
        if essay_response.expiry_date && (essay_response.expiry_date - 7.days).today?
          if essay_response.user.active_enrolled_courses.include?(essay_response.course)
            EssayResponseMailer.expiry_reminder(essay_response).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
          end
        end

        if essay_response.expiry_date && (essay_response.expiry_date - 2.days).today?
          if essay_response.user.active_enrolled_courses.include?(essay_response.course)
            EssayResponseMailer.expiry_reminder_before_2_days(essay_response).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
          end
        end

      end
    end
  end

  def staff_emails
    # Emails of all tutors assigned to same course as the essay

    StaffProfile.includes(:course_staffs).where(course_staffs: { course: user.courses }).joins(:staff).references(:course_staffs).pluck(:email)
  end

  def online_mock_section_timer
    self.assessment_attempt.assessable.online_mock_exam_sections.where(section_type: 3)
  end

  private

  def update_tutor
    if self.course.present? && self.assessment_attempt_id.blank?
      if course.staff_profiles.present?
        tutor = course.staff_profiles.first.staff
        self.update_attribute(:tutor_id, tutor.id)
      end
    end  
  end
end
