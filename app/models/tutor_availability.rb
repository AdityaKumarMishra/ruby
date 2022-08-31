# == Schema Information
#
# Table name: tutor_availabilities
#
#  id            :integer          not null, primary key
#  start_time    :datetime
#  end_time      :datetime
#  location      :text
#  tutor_profile_id       :integer
#  created_at    :datetime         not null
#  updated_at    :datetime         not null
#

class TutorAvailability < ApplicationRecord
  belongs_to :tutor_profile
  belongs_to :tutor_schedule
  has_many :appointments, dependent: :destroy
  has_one :tutor, through: :tutor_profile
  has_one :staff_profile, through: :tutor
  has_many :tags, through: :staff_profile
  has_many :excluded_tags, through: :tutor_profile

  enum repeatability: [:once_off, :weekly, :fortnightly, :monthly]
  enum status: [:active, :deleted]

  validates :start_time, :end_time, presence: true
  validate :valid_start_time, :valid_end_time

  after_save :cast_datetime
  after_update :default_end_date

  scope :current, -> { where('start_time >= ?', Date.today) }
  scope :relevant_tags, lambda { |tag_id| joins(staff_profile: :tags).where(tags: { id: tag_id } ) }
  scope :ascending, -> { order(start_time: :asc) }

  filterrific(
      default_filter_params: { },
      available_filters: [
          :with_start,
          :with_end,
          :with_tag,
          :with_location,
          :with_tutor_name,
          :with_tutor_id
      ]
  )
  scope :with_start,  lambda { |with_start| where('start_time >= ?', with_start.to_date.beginning_of_day) }
  scope :with_end,    lambda { |with_end| where('end_time <= ?', with_end.to_date.end_of_day) }
  scope :with_tag,    lambda { |tag_ids|
    includes(:tags).where("tags.id IN (?)", tag_ids).references(:tags)
  }
  scope :with_location, lambda { |location| includes(tutor: :address).where('addresses.state =?', location).references(:users) }
  scope :with_tutor_id, -> (tutor_id) { includes(:tutor).where("users.id=?", tutor_id) if (tutor_id != "All")}

  scope :with_tutor_name, lambda { |name| includes(:tutor).where("CONCAT_WS(' ', lower(users.first_name), lower(users.last_name)) LIKE ?", "%#{name.downcase}%").references(:users) if (name != "All")}

  scope :sorted_by,   lambda { |sort_option|
    # extract the sort direction from the param value.
    direction = (sort_option =~ /desc$/) ? 'desc' : 'asc'
    case sort_option.to_s
      when /^start_date/
        order("tutor_availabilities.start_date #{ direction }")
      when /^start_time/
        order("tutor_availabilities.start_time #{ direction }")
      when /^user/
        order("tutor_availabilities.tutor #{ direction }")
      else
        raise(ArgumentError, "Invalid sort option: #{ sort_option.inspect }")
    end
  }

  def self.tutor_tags
    Tag.where(id: self.includes(:tags).pluck('tags.id').compact.uniq).order(:name)
  end

  def valid_start_time
    return false if start_time.nil?
    errors.add(:start_time, "Please select a later start time") if start_time <= DateTime.now
  end

  def valid_end_time
    min_in_hour = 60
    return false if end_time.nil? || start_time.nil?
    if (end_time < start_time)
      errors.add(:end_time, "Please set later than start time")
    end
  end

  def default_end_date
    date = Date.parse(self.start_time.to_date.to_s)
    self.update_column(:end_time, end_time.change( { year: date.year, month: date.month, day: date.day } ) )
  end

  def cast_datetime
    self.start_time = self.start_time.to_datetime if self.start_time
    self.end_time = self.end_time.to_datetime if self.end_time
  end

  def self.filter_availabilities(student_tags)
    self.where('start_time >= ?', DateTime.now.next_day(7)).relevant_tags(student_tags).uniq
  end

  def self.get_tutor_availability
    subject = [247, 248, 250, 249]
    umat_subject = [31, 32, 33]
    location = [1,2,3,7,5]
    @tutors = []
    @availabilities = []
    @umat_availabilities = []
    location.each do |loc|
      subarray = []
      umat_subarray = []

      subject.each do |sub|
        available_appointments = TutorAvailability.with_tag(sub).with_location(loc).where('start_time BETWEEN ? AND ?', (Date.today + 1).beginning_of_day, (Date.today + 14).end_of_day)
        @time_slots = TutorAvailability.split_all(available_appointments, User.superadmin.first.appointment_length)
        subarray.push(@time_slots.count)
      end

      umat_subject.each do |sub|
        available_appointments = TutorAvailability.with_tag(sub).with_location(loc).where('start_time BETWEEN ? AND ?', (Date.today + 1).beginning_of_day, (Date.today + 14).end_of_day)
         @time_slots = TutorAvailability.split_all(available_appointments, User.superadmin.first.appointment_length)
        umat_subarray.push(@time_slots.count)
      end

      @availabilities.push(subarray)
      @umat_availabilities.push(umat_subarray)
    end

    subarray = []
    subject.each do |sub|
      tutors = User.tutor.includes(:address, tutor_profile: [tutor_availabilities: :tags]).where(tags: {id: [sub]}, addresses: {state: [location]}).where('tutor_availabilities.start_time BETWEEN ? AND ?', (Date.today + 1).beginning_of_day, (Date.today + 14).end_of_day)
      subarray.push(tutors.map {|tutor| tutor.full_name}.join(", "))
    end
    @availabilities.push(subarray)

    subarray = []
    umat_subject.each do |sub|
      tutors = User.tutor.includes(:address, tutor_profile: [tutor_availabilities: :tags]).where(tags: {id: [sub]}, addresses: {state: [location]}).where('tutor_availabilities.start_time BETWEEN ? AND ?', (Date.today + 1).beginning_of_day, (Date.today + 14).end_of_day)
      subarray.push(tutors.map {|tutor| tutor.full_name}.join(", "))
    end
    @umat_availabilities.push(subarray)
    User.where(private_tutor_subscribe_email: true).each do |user|
      BookTutorMailer.fornight_auto_email(user, @availabilities, @umat_availabilities, subject, location).deliver_later
    end
  end

  # length: appointment length in minutes
  def get_available_times(length)
    available_slots = []
    available_slots += [[self.start_time, self.end_time]]
    self.appointments.active.ascending.each do |a|
      time_slot = available_slots.pop
      available_slots += remove_booked_times(time_slot, a)
    end
    split(available_slots, length)
  end

  def remove_booked_times(time_slot, appointment)
    if appointment.start_time == time_slot[0]
      [[appointment.end_time, time_slot[1]]]
    elsif appointment.end_time == time_slot[1]
      [[time_slot[0], appointment.start_time]]
    else
      [[time_slot[0], appointment.start_time], [appointment.end_time, time_slot[1]]]
    end
  end

  def split(available_slots, length)
    time_slots = []

    available_slots.each do |available_slot|
      start = available_slot[0]
      finish = available_slot[0] + length.minutes
      while finish <= available_slot[1]
        time_slots << [start, finish]
        start += length.minutes
        finish += length.minutes
      end
    end
    time_slots
  end

  def self.split_all(availabilities, length)
    time_slots = []
    return time_slots unless availabilities.present?
    availabilities.includes(:tutor, :tags).each do |availability|
      availability.get_available_times(length).each do |time_slot|
        time_slots << [availability, time_slot, Tag.child_tags(availability.tags)]
      end
    end
    time_slots
  end

  def self.get_all_relevant_tags(tags)
    student_tags = []
    tags.each do |tag|
      student_tags += tag.self_and_descendants
    end
    student_tags
  end
end
