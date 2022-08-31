# == Schema Information
#
# Table name: contact_locations
#
# t.string   "name"
# t.integer  "class_size"
# t.date     "expiry_date"
# t.datetime "enrolment_end_date"
# t.integer  "product_version_id"
# t.datetime "created_at",                       null: false
# t.datetime "updated_at",                       null: false
# t.string   "slug",                             null: false
# t.boolean  "is_active"
# t.integer  "essay_time",         default: 120
# t.integer  "mcq_quantity"
#

class Course < ApplicationRecord
  attr_accessor :product_line, :transfer_data_to_tutor

  belongs_to :product_version
  has_many :lessons, dependent: :destroy
  has_many :course_versions, dependent: :destroy
  accepts_nested_attributes_for :lessons, allow_destroy: true
  has_many :enrolments, dependent: :destroy
  has_many :course_staffs, dependent: :destroy
  has_many :staff_profiles, through: :course_staffs
  has_many :users, through: :enrolments
  has_many :transfer_transactions, dependent: :destroy
  has_many :essay_responses, dependent: :destroy
  has_many :product_version_feature_prices, through: :product_version
  has_many :master_features, through: :product_version_feature_prices
  has_many :live_exams, dependent: :nullify
  has_many :exercises
  has_many :mock_exam_essays, dependent: :nullify
  has_many :waitlist_users, dependent: :destroy
  has_many :textbooks, dependent: :destroy
  accepts_nested_attributes_for :textbooks, allow_destroy: true
  after_save :syncronize_enrolments_status, if: ->{ saved_change_to_expiry_date? }
  before_save :validate_class_size

  extend FriendlyId
  friendly_id :name, use: :slugged

  validates :name, presence: true

  validates :class_size, :city, :enrolment_end_date, :product_version_id, :expiry_date, :staff_profile_ids, presence:true

  validates :trial_period_days, numericality: { greater_than: 0 }, if: :trial_enabled?
  validates :paypal_days ,numericality: { greater_than: 0 }

  # validate :course_student_count_less_then_class_size, if: -> {class_size.present?}

  delegate :price, to: :product_version
  enum city: [ "Melbourne", "Sydney", "Brisbane", "Adelaide", "Perth", "Canberra",
               "Sept-GAMSAT Melbourne", "Sept-GAMSAT Sydney", "Sept-GAMSAT Brisbane",
               "Sept-GAMSAT Adelaide", "Sept-GAMSAT Perth", "Other"
             ]
  scope :by_product_version, -> (pv_id) { joins(:product_version).where(product_versions: { id: pv_id }) }
  scope :by_master_feature, -> (mf_id) { mf_id.present? ? joins(:master_features).where(master_features: { id: mf_id }) : all }
  scope :by_product_line, -> (product_line) { where(product_version_id: ProductVersion.where('type like ?', "#{product_line}%")) }

  CITIES = { victoria: [Course.cities['Melbourne'], Course.cities['UK-GAMSAT Melbourne']],
             new_south_wales: [Course.cities['Sydney'], Course.cities['UK-GAMSAT Sydney']],
             queensland: [Course.cities['Brisbane'], Course.cities['UK-GAMSAT Brisbane']],
             south_australia: [Course.cities['Adelaide'], Course.cities['UK-GAMSAT Adelaide']],
             australian_capital_territory: [Course.cities['Other']],
             northern_territory: [Course.cities['Other']],
             western_australia: [Course.cities['Perth'], Course.cities['UK-GAMSAT Perth']],
             tasmania: [Course.cities['Other']],
             other: [Course.cities['Other']]
             }.freeze

  filterrific(
    available_filters: [
      :with_city,
      :with_pv,
      :with_name,
      :by_product_line
    ]
  )


  scope :active_courses, -> { where('expiry_date > ? OR show_archived = ?', Time.zone.now.beginning_of_day, true) }
  scope :archived_courses, -> { where('expiry_date < ? AND show_archived = ?', Date.today, false) }
  scope :with_city, -> (city){ where(city: city)}
  scope :with_pv, -> (product_version_id) { where(product_version_id: product_version_id) }

  scope :with_name, lambda { |query|
    return nil if query.blank?
    term = query.to_s.downcase
    term = ('%' + term.tr('*', '%') + '%').gsub(/%+/, '%')
    where('(LOWER(courses.name) LIKE ?)', term)
  }
  after_update :check_changed_product_version

  def syncronize_enrolments_status
    if expiry_date > Time.zone.now.beginning_of_day
      enrolments.includes(:order).where("orders.status !=?", 0).references(:order).where(state: 'Unenrolled').find_each do |enrolment|
        if enrolment.previous_state_before_unenrolled.present?
          enrolment.update!(state: enrolment.previous_state_before_unenrolled)
        else
          enrolment.update!(state: 'Applied')
        end
      end
    else
      enrolments.includes(:order).where("orders.status !=?", 0).references(:order).where.not(state: 'Unenrolled').find_each do |enrolment|
        enrolment.update!(state: 'Unenrolled')
        EnrolmentsMailer.unenrollment_notification(enrolment).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false" && enrolment.paid_at.present?
      end
    end
  end

  def validate_class_size
    if class_size < paid_enrolments_with_pending.count
      errors.add(:class_size, "Enrolment limit cannot be less than Total Enrolment (Sum of Paid and Unpaid Students)")
      raise StandardError.new("Enrolment limit cannot be less than Total Enrolment (Sum of Paid and Unpaid Students)")
    end

    true
  end

  def paypal_description
    # TODO: Add location and start date and end date
    "
      #{product_version.type} - #{city} -
      #{enrolment_end_date.to_date.strftime('%d %b %Y')}
      to
      #{expiry_date.strftime('%d %b %Y')} - #{product_version.name}
    "
  end

  def paid_enrolments
    enrolments.includes(purchase_item: :order).where("orders.status !=? AND orders.status !=? AND enrolments.state != ?", 0, 1, 3).references(:orders)
  end

  def paid_enrolments_with_pending
    enrolments.includes(:order).where("orders.status !=? AND enrolments.state != ?", 0, 3).references(:order)
  end

  def self.options_for_city
    Course.cities.map {|k,v| [k, v]}.sort_by { |city, code| city }
  end

 ###Not used as enrol.html.erb is also not used where it was used before ####
  # def paypal_total
  #   price + tax + paypal_fee
  # end

 #### used in transfer transactions ####
  def bank_total
    price + tax
  end

  def tax
    price * 0.1
  end

  # def paypal_fee
  #   (price + tax) * 0.02
  # end

  # def paypal_subtotal
  #   paypal_fee + price
  # end

  def self.num_courses_created_by(product_id)
    total = Course.where(product_version_id: product_id).length
    total
  end

  def course_full?
    # Returns whether the course is full and no more enrolments should be accepted
    if paid_enrolments_with_pending.count >= class_size
      true
    else
      false
    end
  end

  def enrolments_full?
    # Returns whether the course enrolment is full and no more enrolments should be accepted
    # GRAD-3019
    if paid_enrolments_with_pending.count >= class_size
      true
    else
      false
    end
  end

  def full_alert?
    if class_size.present? && ((enroled_student_list.count + enroled_unpaid_student_list.count) == class_size - 2)
      true
    else
      false
    end
  end

  def expired?
    expiry_date < Time.zone.now.beginning_of_day
  end

  def staff_tutor_profiles
    StaffProfile.includes(:staff).where('staff_profiles.id IN (?) OR users.role = (?)', staff_profiles.ids, 1).references(:users).order("first_name ASC")
  end

  ##### obselete code not in use now #####
  # def paypal_hash(return_url, cancel_url)
  #   { intent: 'sale',

  #     payer: { payment_method: 'paypal' },

  #     redirect_urls: { return_url: return_url,
  #                      cancel_url: cancel_url },

  #     transactions: [{
  #       item_list: {
  #         items: [{
  #           name: paypal_description,
  #           price: convert_to_currency(price + paypal_fee),
  #           currency: 'AUD',
  #           quantity: 1
  #         }]
  #       },

  #       amount: {
  #         total: convert_to_currency(paypal_total),
  #         currency: 'AUD',
  #         details: {
  #           subtotal: convert_to_currency(price + paypal_fee),
  #           tax: convert_to_currency(tax)
  #         }
  #       },

  #       description: paypal_description
  #     }] }
  # end

  def course_type
    out = ''
    if product_version.present?
      out = case product_version.type
            when 'GamsatReady'
              '[GR Student] '
            when 'UmatReady'
              '[UR Student] '
            when 'VceReady'
              '[VCE Student] '
            when 'HscReady'
              '[HSC Student] '
            else
              '[New Student] '
            end
    end
    out
  end


  def student_list
    enrolments.includes(:user).where("users.id IS NOT NULL AND enrolments.state != 3 AND enrolments.paid_at IS NOT NULL").references(:user)
  end

  def enroled_student_list
    enrolments.includes(:user).where("users.id IS NOT NULL AND enrolments.state != 3").includes(:order).where('orders.status NOT IN (0)').references(:user)
  end

  def enroled_paid_student_list
    enrolments.includes(:user).where("users.id IS NOT NULL AND enrolments.state != 3").includes(:order).where('orders.status NOT IN (0, 6)').references(:user)
  end

  def placeholder_student_list
    enrolments.includes(:user).where("users.id IS NOT NULL AND enrolments.state != 3").includes(:order).where('orders.status = 6').references(:user)
  end

  def enroled_unpaid_student_list
    enrolments.includes(:user).where("users.id IS NOT NULL AND enrolments.state != 3").includes(:order).where('orders.status = 1').references(:user)
  end


  def course_student_count_less_then_class_size
    if self.student_list.count > class_size
      errors.add(:class_size, "Class size must be greater than student enrolled in course.")
    end
  end

  def tutor_assigned?
    roles = User.where(id: staff_profiles.pluck(:staff_id)).pluck(:role)
    names=[]
    staff_profiles.each do |staff_profile|
      names<< staff_profile.staff.full_name
    end
    roles.include?("tutor") ? "#{names.join(", ")}" : "None"
  end

  def tags_cache
    tagging_ids = Tagging.where(taggable_type: 'ProductVersionFeaturePrice', taggable_id: product_version_feature_prices.ids).ids
    tags = Tag.includes(:taggings).where(taggings: {id: tagging_ids })
    Rails.cache.fetch("course-#{cache_key}/tags", expires_in: 2.hour) do
      tags
        .map(&:self_and_descendants)
        .flatten
    end
  end

  def has_hardcopy_feature
    feature = product_version_feature_prices.where(is_default: true).map{|p| p.master_feature}.select { |feature| feature.hardcopy? }
    feature.present? ? true : false
  end

  def self.send_expiry_notification
    Course.all.each do |course|
      if course.expiry_date.present? && ((course.expiry_date - 7.days) == Date.today)
        course.student_list.each do |e|
          user = e.user
          CoursesMailer.expiry_notification_before_7_days(course, user).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
        end
      end

      if course.expiry_date == Date.today
        course.student_list.each do |e|
          user = e.user
          CoursesMailer.expiry_notification(course, user).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
        end
      end
    end
  end


  def self.send_live_classes_mail
    Course.active_courses.all.each do |course|
      course.lessons.where(lesson_type: 0).first(5).each_with_index do |lesson, index|
        if lesson.date && lesson.date.today?
          course.student_list.each do |e|
            u = e.user
            next if u.confirmed_at.nil?
            CoursesMailer.live_classes_mail(index + 1, lesson, course, u).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
          end
        end
      end
    end
  end

  def self.send_mock_classes_mail
    Course.active_courses.all.each do |course|
      lesson = course.lessons.where(lesson_type: 1).last
      if lesson && lesson.date && lesson.date.today?
        course.student_list.each do |e|
          u = e.user
          next if u.confirmed_at.nil?
          CoursesMailer.mock_classes_mail(lesson, course, u).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
        end
      end
    end
  end

  def downloadable_course_present
    case product_version.try(:course_type)
    when 'free_trial'
      Document.where(for_trial: true).present?
    when 'attendance_essential', 'attendance_comprehensive', 'attendance_complete'
      Document.where('for_paid = true OR for_timetable = true').present?
    else
      Document.where(for_paid:true).present?
    end
  end

  def student_testimonial_page
    case product_version.type
    when 'GamsatReady'
      '/gamsat-preparation-courses/student_testimonials'
    when 'UmatReady'
      '/umat-preparation-courses/student_testimonials'
    when 'HscReady'
      '/hsc/student_testimonials'
    when 'VceReady'
      '/vce/student_testimonials'
    else
      ''
    end
  end

  def image_up
    ActionController::Base.helpers.image_tag("https://gradready.s3.ap-southeast-2.amazonaws.com/static/student_pages/collpase_icon.svg", class: 'up_sign hide')
  end

  def image_down
    ActionController::Base.helpers.image_tag("https://gradready.s3.ap-southeast-2.amazonaws.com/static/student_pages/full_schedule.svg", class: 'down_sign')
  end

  def update_essay_response_tutor(essay_marker_id)
    essay_responses = self.essay_responses.where(status: 0)
    staff_profile = StaffProfile.find_by(id: essay_marker_id)
    tutor = staff_profile.staff if staff_profile.present?
    essay_responses.update_all(tutor_id: tutor.id) if tutor.present?
  end

  private

  def convert_to_currency(number)
    format('%.2f', number).to_s
  end

  def check_changed_product_version
    if product_version_id_changed?
      paid_enrolments.each do |enrolment|
        product_version.product_version_feature_prices.where(is_additional: false).each do |pf|
          acquired = pf.is_default ? DateTime.now : nil
          fe = pf.feature_logs.find_by(enrolment_id: enrolment.id, qty: pf.qty)
          fe = pf.feature_logs.create(acquired: acquired, enrolment_id: enrolment.id, qty: pf.qty) unless fe.present?
          fe.assign_hours_if_pv_changed(self.id) if pf.master_feature.private_tutoring? && pf.is_default
        end
      end
    end
  end

  def self.check_alreday_link_course(course)
    pv = ProductVersion.find_by(id: 105)
    if pv.present?
      c = pv.courses.where('enrolment_end_date >= ? AND link_with_homepage_ft = ?', Time.zone.now.beginning_of_day, true).order('id DESC').select{|p| !p.enrolments_full?}.first
      if c.present?
        if course.new_record? && c.present?
          return true
        elsif course.id == c.id
          return false
        else
          return true
        end
      else
        return false
      end
    end
  end
end
