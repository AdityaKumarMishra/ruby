# == Schema Information
#
# Table name: tutor_schedules
#
#  id             :integer          not null, primary key
#  repeatability  :integer
#  start_time     :datetime
#  end_time       :datetime
#  location       :text
#  tutor_availability_id   :integer
#  created_at     :datetime         not null
#  updated_at     :datetime         not null
#

class TutorSchedule < ApplicationRecord
  belongs_to :tutor_profile
  has_many :tutor_availabilities, dependent: :destroy

  enum repeatability: [:once_off, :weekly, :fortnightly, :monthly]

  validates :start_time, :end_time, :repeatability, presence: true
  validate :valid_start_time, :valid_end_time

  before_create :cast_datetime
  after_create :build_schedule, :update_end_time
  after_update :update_location


  def valid_start_time
    errors.add(:start_time, "Please select a later start Date and Time") if start_time.to_i <= DateTime.now.to_i
  end

  def valid_end_time
    return false if end_time.nil? || start_time.nil?
    if repeatability != 'once_off' && end_time < start_time
      errors.add(:end_time, "Please set later than start Date and Time")
    end
  end


  def cast_datetime
    self.start_time = self.start_time.to_datetime if self.start_time
    self.end_time = self.end_time.to_datetime if self.end_time
  end

  def account_for_midnight(start, finish)
    if finish < start
      finish = finish + 1.day
    end
    finish
  end

  def build_schedule
    skip_week = 7
    skip_fortnight = 14
    skip_month = 1
    if self.once_off?
      self.build_tutor_availability
    elsif self.weekly?
      self.create_weekly_availabilities(skip_week)
    elsif self.fortnightly?
      self.create_weekly_availabilities(skip_fortnight)
    elsif self.monthly?
      self.create_monthly_availabilities(skip_month)
    end
  end

  def create_weekly_availabilities(days_to_skip)
    days_skipped = 0
    # start = self.start_time.to_datetime.next_day(days_skipped)
    start = self.start_time.next_day(days_skipped).to_datetime
    while start <= self.end_time.to_datetime
      self.build_tutor_availability(start)
      days_skipped += days_to_skip
      start = self.start_time.next_day(days_skipped).to_datetime
    end
  end

  def create_monthly_availabilities(months_to_skip)
    months_skipped = 0
    start = self.start_time.next_month(months_skipped).to_datetime
    while start <= self.end_time.to_datetime
      self.build_tutor_availability(start)
      months_skipped += months_to_skip
      start = self.start_time.next_month(months_skipped).to_datetime
    end
  end

  def build_tutor_availability(available_start_time=nil)
    available_start_time = self.start_time.to_datetime unless available_start_time
    available_end_time = self.build_end_time(available_start_time, self.end_time)
    tutor_availability = TutorAvailability.new(
                                                start_time: available_start_time,
                                                end_time: available_end_time,
                                                location: self.location,
                                                tutor_profile: self.tutor_profile,
                                                tutor_schedule_id: self.id
    )
    tutor_availability.save# if tutor_availability.valid?
  end

  def build_end_time(start, finish_time)
    date = Date.parse(start.to_date.to_s)
    finish = finish_time
    finish = finish.change( { year: date.year, month: date.month, day: date.day } )
    finish = account_for_midnight(start, finish)
  end

  def self.delete_tutor_schedule
    tutor_schedules = TutorSchedule.where("end_time<?", Time.zone.now + 7.days)
    tutor_schedules.all.each do |t_schedule|
      count = 0
      t_schedule.tutor_availabilities.all.each do |ta|
        if ta.appointments.present?
          count = count + 1;
        end
      end
      if count == 0
        t_schedule.destroy
      end
    end
  end

  def update_end_time
    if self.repeatability == 'once_off'
      start_date = self.start_time.to_date
      end_time = self.end_time
      new_end_time = Time.zone.local(start_date.year, start_date.month,
                               start_date.day, end_time.hour,
                               end_time.min, end_time.sec)
      self.update(end_time: new_end_time)
    end
  end

  def update_location
    tutor_availabilities.update_all(location: self.location)
  end

end
