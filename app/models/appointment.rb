# == Schema Information
#
# Table name: appointments
#
#  id         :integer          not null, primary key
#  student_id :integer
#  start_time :datetime
#  end_time   :datetime
#  location   :text
#  tutor_availability_id   :integer
#  created_at :datetime         not null
#  updated_at :datetime         not null


class Appointment < ApplicationRecord
  include EventableItem

  belongs_to :student, class_name: 'User'
  belongs_to :feature_log, optional: true
  belongs_to :tutor, class_name: 'User'
  has_one :staff_profile, through: :tutor
  has_many :tags, through: :staff_profile
  has_many :appointment_hours, dependent: :destroy
  belongs_to :course

  after_create :notify_of_creation
  after_create :create_appointemnt_hour
  scope :ascending, -> { order(created_at: :asc) }
  scope :active, -> { where(status: Appointment.statuses[:active]) }
  

  filterrific(
      default_filter_params: { },
      available_filters: [
          :with_start,
          :with_end
      ]
  )
  scope :with_start, lambda { |with_start| where('DATE(appointments.finish_date) >= ?', with_start.to_date) }
  scope :with_end, lambda { |with_end| where('DATE(appointments.finish_date) <= ?', with_end.to_date) }
  scope :created_with_start, lambda { |with_start| where('DATE(appointments.created_at) >= ?', with_start.to_date) }
  scope :created_with_end, lambda { |with_end| where('DATE(appointments.created_at) <= ?', with_end.to_date) }

  enum status: [:active, :deleted]

  #updated to 2 days instead of 10 days as required in task #GRAD-3059
  scope :last_ten_days_appointments, -> { where("Date(created_at) >= ?", Date.today - 2.days) }


  def created_hours
    (Time.zone.now - created_at)/3600
  end

  def self.default_pay_periods
    selected_date = []
    from_filter = to_filter = nil
    self.pay_periods.each do |ap|
      pay_period_date = ap[0].split(' - ')
      from_date = pay_period_date[0]
      upto_date = pay_period_date[1]
      if from_date.to_date <= Date.today  && Date.today <= upto_date.to_date
        selected_date << ap
        from_filter = from_date
        to_filter  = upto_date
      end
    end
    return selected_date.flatten[0],from_filter,to_filter 
  end

  def not_count_weekends
    case created_at.wday
      when 1 , 2
        72
      when 3, 4 , 5
        120
      when 6
        hours_get = (created_at.end_of_day - created_at) / 1.hours
        96 + hours_get
      when 0
        hours_get = (created_at.end_of_day - created_at) / 1.hours
        72 + hours_get
    end
  end

  def self.pay_periods
    pay_base = pay_period_base
    pay_periods = []

    # show last 5 and next 10 pay periods
    pay_period_end = 10
    pay_period_start = -5

    (pay_period_start..pay_period_end).each do |i|
      pay_periods.push(["#{pay_base[0] + (i * 14)} - #{pay_base[1] + (i * 14)}"])
    end
    pay_periods
  end

  def self.pay_period_base
    start_date = Time.zone.today
    fix_start_date = Date.parse("04/09/2017")
    diff = (start_date - fix_start_date).to_i
    remain = diff % 14
    add_to = diff - remain
    initial_start_date = fix_start_date + add_to
    p1_start = initial_start_date
    p1_end = p1_start + 13
    [p1_start, p1_end]
  end

  def appointment_info
    st_time = start_time.present? ? start_time.strftime('%d %b %H:%M').to_s : ""
    en_time = end_time.present? ? end_time.strftime('%H:%M').to_s : ""
    tag_name = tags.present? ? tags.first.name : ""
    tutor.first_name + " - " + st_time + " - " +  en_time + " - " + tag_name
  end

  def notify_of_creation
    if ENV['EMAIL_CONFIRMABLE'] != "false"
      BookTutorMailer.make_student_booking(self).deliver_later
      BookTutorMailer.make_tutor_booking(self).deliver_later
    end
  end

  def self.for_tutor user
    self.ordered.joins(tutor_availability: :tutor_profile).where( tutor_profiles: { id: user.tutor_profile.id } )
  end

  def self.for_student user
    self.ordered.where(student: user)
  end

  def set_time_left(new_hours, appointment_hour)
    feature_log = self.student.private_tutor_enrolment(student.active_course)
    return unless feature_log.present?
    self.update(feature_log_id: feature_log.id, finish_date: Date.today)
    new_time = feature_log.qty - (new_hours)
    feature_log.update_attribute(:qty, new_time)
    appointment_hour.update(left_hours: new_time)
  end

  def retrieve_events
    [to_event]
  end

  def can_cancel?
    return true if start_time.blank?

    days = (start_time.to_date - Date.today).to_i
    days >= 7 ? true : false
  end

  def self.escalation_reminder
    if ENV['EMAIL_CONFIRMABLE'] != "false"
      Appointment.last_ten_days_appointments.each do |app|
        check_hours = app.not_count_weekends
        if ((app.created_hours >= check_hours) && (app.created_hours < (check_hours + 1)))
            BookTutorMailer.check_response_regarding_appointment(app).deliver_later
        end
      end
    end
  end

  def create_appointemnt_hour
    feature_log = student.private_tutor_enrolment(student.active_course)
    return unless feature_log.present?
    self.appointment_hours.create(hours: 0, left_hours: feature_log.qty, finish_date: Time.zone.now.to_date)
  end

  private

  def to_event
    EventItem.new(
        name: 'Appointment',
        tutor: tutor,
        student: student,
        time_start: tutor_availability.start_time,
        time_end: tutor_availability.end_time,
        type: self.class.name,
        id: id
    )
  end
end
