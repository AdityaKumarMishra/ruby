class Enrolment < ApplicationRecord
  # t.integer  "user_id"
  # t.datetime "created_at",     null: false
  # t.datetime "updated_at",     null: false
  # t.integer  "course_id"
  # t.string   "paypal_payment"
  # t.string   "paypal_token"
  # t.datetime "paid_at"
  # t.string   "promo"
  # t.string   "banktrans"
  # t.float    "subtotal"
  # t.float    "gst"
  # t.float    "paypal_fee"
  scope :paid, -> { where.not(paid_at: nil) }
  belongs_to :course
  has_one :product_version, through: :course
  has_many :purchase_addons, dependent: :nullify
  validates :course, presence: true
  validates :trial_expiry, presence: true, if: :trial?
  validate :course_uniqueness
  has_one :purchase_item, as: :purchasable, dependent: :destroy
  has_many :feature_logs, dependent: :destroy
  has_one :order, through: :purchase_item
  has_one :user, through: :order
  has_one :product_version, through: :course
  before_save :update_previous_state_before_unenrolled, if: ->{ state_changed? && state == 'Unenrolled' }
  after_update :update_course_state

  validates :course, presence: true

  enum state: [ 'Applied', 'Enrolled', 'Manual Enrolment', 'Unenrolled', 'Transferred']

  filterrific(
    available_filters: [
      :by_product_line,
      :with_pv,
      :with_city
    ]
  )

  def update_course_state
    course.update(enrolment_end_date: Date.today - 2.days) if paid_at.present? && state != 'Unenrolled' && course.paid_enrolments_with_pending.count >= course.class_size
  end

  def update_previous_state_before_unenrolled
    self.previous_state_before_unenrolled = state_was
  end

  def valid_for_purchase?
    !(course.course_full? || course.enrolment_end_date.nil? || course.enrolment_end_date < Time.zone.now.beginning_of_day)
  end

  def activate(course=nil, old_enrolment=nil, deactivate_feature=nil)
    # Function is called when order finalises a pay,
    # it makes the enrolment active.
    if trial
      update(paid_at: Time.zone.now)
    else
      update(paid_at: Time.zone.now, trial: false, trial_expiry: nil)
    end

    user.update(first_enrolment_date: Date.today) if user.first_enrolment_date.nil?
    enrol_features(old_enrolment)
    user.update_attribute(:active_course_id, self.course.id)
    purchased_course_type= ProductVersion.course_types[self.course.product_version.course_type]
    unless order.creator.present? && (order.creator.admin? || order.creator.superadmin? || order.creator.manager?)
      if ENV['EMAIL_CONFIRMABLE'] != "false"
        if user.confirmed_at.present?
          EnrolmentsMailer.staff_new_enrolment(self).deliver_later unless try(:purchase_item).try(:order).free?
          EnrolmentsMailer.student_new_enrolment(self).deliver_later
          EnrolmentsMailer.discount_link_auto_email(self).deliver_later if order.generated_promo.present?
          OrdersMailer.staff_new_banktrans(order).deliver_later if (purchased_course_type == 10)
          check_customise_email_templates
        else
          user.mail_pendings.create(enrolment_id: self.id, category: "EnrolmentsMailer", method: 'staff_new_enrolment(enrolment)', status: 0) unless try(:purchase_item).try(:order).free?
          user.mail_pendings.create(enrolment_id: self.id, category: "EnrolmentsMailer", method: 'student_new_enrolment(enrolment)', status: 0)
          user.mail_pendings.create(enrolment_id: self.id, category: "EnrolmentsMailer", method: 'discount_link_auto_email(enrolment)', status: 0) if order.generated_promo.present?
          user.mail_pendings.create(order_id: order.id, category: "OrdersMailer", method: 'staff_new_banktrans(order)', status: 0) if (purchased_course_type == 10)
        end
      end
    end
  end

  def activate_trial
    if update(paid_at: Time.zone.now, trial: true,
                      trial_expiry: course.expiry_date,
                      state: Enrolment.states['Enrolled'])
      user.update_attribute(:active_course_id, self.course.id)
      enrol_features
      unless order.creator.present? && (order.creator.admin? || order.creator.superadmin? || order.creator.manager?)
        if ENV['EMAIL_CONFIRMABLE'] != "false"
          if user.confirmed_at.present?
            OrdersMailer.staff_new_banktrans(order).deliver_later
            EnrolmentsMailer.student_new_free_trail_enrolment(self).deliver_later if !self.product_version.is_pre_employment?
          else
            user.mail_pendings.create(order_id: order.id, category: "OrdersMailer", method: 'trial_course_congratulation(order)', status: 0) if ProductVersion.course_types[self.course.product_version.course_type] == 0
            user.mail_pendings.create(order_id: order.id, category: "OrdersMailer", method: 'staff_new_banktrans(order)', status: 0)
            user.mail_pendings.create(enrolment_id: self.id, category: "EnrolmentsMailer", method: 'student_new_free_trail_enrolment(enrolment)', status: 0)
          end
        end
      end
    else
    end
  end

  def check_customise_email_templates
    course = self.course
    course_ids = course.try(:id)
    product_version_ids = course.product_version.try(:id)
    master_feature_ids = []
    self.order.purchase_items.each do |purchase_item|
      if purchase_item.purchasable_type == "FeatureLog"
        pvfp = purchase_item.try(:purchasable).try(:product_version_feature_price)
        master_feature_ids << pvfp.master_feature_id
      end
    end
    self.feature_logs.where.not(acquired: nil, description: nil).each do |feature_log|
      master_feature_ids << feature_log.product_version_feature_price.master_feature_id
    end
    email_templates = []

    email_templates << EmailCustomise.includes(:courses, :product_versions, :master_features).where("courses.id IN (?) AND product_versions.id IN (?) AND master_features.id IN (?)", course_ids, product_version_ids, master_feature_ids).references(:courses, :product_versions, :master_features)

    email_templates << EmailCustomise.includes(:courses, :product_versions, :master_features).where("courses.id IN (?) AND product_versions.id IN (?) AND master_features.id IS NULL", course_ids, product_version_ids).references(:courses, :product_versions)

    email_templates << EmailCustomise.includes(:courses, :master_features, :product_versions).where("courses.id IN (?) AND master_features.id IN (?) AND product_versions.id IS NULL", course_ids, master_feature_ids).references(:courses, :master_features)

    email_templates << EmailCustomise.includes(:product_versions, :master_features, :courses).where("product_versions.id IN (?) AND master_features.id IN (?) AND courses.id IS NULL", product_version_ids, master_feature_ids).references(:product_versions, :master_features)

    email_templates << EmailCustomise.includes(:courses, :product_versions, :master_features).where("courses.id IN (?) AND product_versions.id IS NULL AND master_features.id IS NULL", course_ids).references(:courses)

    email_templates << EmailCustomise.includes(:product_versions, :courses, :master_features).where("product_versions.id IN (?) AND courses.id IS NULL AND master_features.id IS NULL", product_version_ids).references(:product_versions)

    email_templates << EmailCustomise.includes(:master_features, :courses, :product_versions).where("master_features.id IN (?) AND courses.id IS NULL AND product_versions.id IS NULL", master_feature_ids).references(:master_features)

    email_templates = email_templates.flatten.uniq if email_templates.present?
    email_templates.each do |email_template|
      if email_template.publish?
        EnrolmentsMailer.student_new_customise_enrolment(self, email_template).deliver_later
      end
    end if email_templates.present?
  end

  def deactivate
    update(paid_at: nil)
    destroy
  end

  # def active_features
  #   feature_enrolments.includes(:feature).where(active: true).select do |fe|
  #     fe.feature.present?
  #   end
  # end

  # def inactive_features
  #   feature_enrolments.includes(:feature).where(active: false).select do |fe|
  #     fe.feature.present?
  #   end
  # end

  def paid?
    !paid_at.nil?
  end

  def paid!
  end

  def trial_since_enrolment_average_number_of_time_logged_in_per_day
    login_count = user.sign_in_count - signin_count_enrolment
    if created_at.today?
      login_count.to_f
    elsif trial? && trial_expired?
      (expire_signin_count - signin_count_enrolment).to_f
    else
      (login_count.to_f / (Date.today - created_at.to_date).to_f).round(3)
    end
  end

  def trial_since_enrolment_average_number_of_min_spend_per_day
    online_minutes_spend = user.total_online_time - total_online_time_enrolment
    if created_at.today?
      online_minutes_spend.to_f
    elsif trial? && trial_expired?
      (expire_total_online_time - total_online_time_enrolment).to_f
    else
      (online_minutes_spend.to_f / (Date.today - created_at.to_date).to_f).round(3)
    end
  end

  def trial_sign_in_count_from_enrolment
    if trial_expired?
      expire_signin_count - signin_count_enrolment
    else
      user.sign_in_count - signin_count_enrolment
    end
  end

  def trial_total_online_time_from_enrolment
    if trial_expired?
      expire_total_online_time - total_online_time_enrolment
    else
      user.total_online_time - total_online_time_enrolment
    end
  end

  def self.update_enrolment_trial
    trial_enrolments = Enrolment.where(trial: true)
    check_date = Date.today - 1.day
    trial_enrolments.each do |enrolment|
      if check_date == enrolment.trial_expiry.to_date
        enrolment.update(expire_signin_count: enrolment.user.sign_in_count)
        enrolment.update(expire_total_online_time: enrolment.user.total_online_time)
      end
    end
  end

  def trial_expired?
    return nil unless trial?
    trial_expiry <= Time.zone.now
  end

  def product_line_type
    return 'GradReady' if course.product_version.nil?

    case course.product_version.type
    when 'GamsatReady'
      'GAMSAT'
    when 'UmatReady'
      'UMAT'
    when 'VceReady'
      'VCE'
    when 'HscReady'
      'HSC'
    else
      'GradReady'
    end
  end

  # Makes sure user has all the features that are default to the product version
  # def update_user_features
  #   course.product_version.features.each do |feature|
  #     feature_enrolments.create(feature: feature, active: true)
  #   end
  # end

  def self.send_free_trial_expiry_mail_after_14_days
    date = Time.zone.now + 2.days
    free_trial_course_ids = Course.where("name ILIKE ? AND DATE(expiry_date) >= ?", "%free trial%", Date.today).pluck(:id) 
    enrolments = Enrolment.joins(:user).where("course_id IN (?) AND DATE(created_at) = ? ", free_trial_course_ids, Date.today - 14.days)
    enrolments.each do |user, enrolments|
      custom_courses = user.courses.includes(:product_version).where.not(product_versions: { course_type: ProductVersion::course_types['free_trail'] })
      unless custom_courses.present?
        EnrolmentsMailer.free_trial_expiry_mail_before_2_days(enrolment).deliver_later
      end
    end
  end

  def self.send_free_trial_expiry_mail_today
    # if Rails.env.production?
    #   date = Time.zone.now
    #   enrolments = Enrolment.where("trial =? AND trial_expiry BETWEEN ? AND ?", true, date.beginning_of_day, date.end_of_day)
    #   enrolments.each do |enrolment|
    #     EnrolmentsMailer.free_trial_expiry_mail_today(enrolment).deliver_later if enrolment.user && enrolment.user.paid_enrolments.find_by(trial: false).blank? && ENV['EMAIL_CONFIRMABLE'] != "false"
    #   end
    # end
  end

  def extend_free_trial(by)
    update(trial_expiry: trial_expiry + by.days) if trial?
  end

  def self.unenroll_expired_courses
    beg_of_day = Time.zone.now.beginning_of_day
    includes(:course).where(
                              "((trial = ? AND trial_expiry < ?)
                              OR
                              (courses.expiry_date < ?))
                              AND state != ?",
                              true,
                              Time.zone.now,
                              beg_of_day,
                              states['Unenrolled']
                            ).references(:courses).each do |e|
                              e.update(state: states['Unenrolled'])
                              EnrolmentsMailer.unenrollment_notification(e).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false" && e.paid_at.present?
                            end
  end

  def live_exam
    user.live_exams.find_by(course_id: course.id)
  end

  def change_status_to_tansferred
    self.update_attribute(:state, Enrolment.states['Transferred'])
  end

  def unenrol
    self.update_attribute(:state, Enrolment.states['Unenrolled'])
    EnrolmentsMailer.unenrollment_notification(self).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false" && paid_at.present?
  end

  def transfer_old_course_data_to_new_course(old_enrolment)
    old_course = old_enrolment.course
    new_course = course
    old_essay_fl = old_enrolment.feature_logs.where.not(acquired: nil).select{ |f| f.master_feature.essay?}
    #create old course essay responses if not present?
    if user.essay_responses.blank? && old_essay_fl.present?
      old_essay_fl.first.assign_essays(false, old_course.product_version.id)
    end
    #Assign Essays to new course
    if new_course.staff_profiles.present?
      tutor_id = new_course.staff_profiles.first.staff.try(:id)
    else
      tutor_id = nil
    end
    essay_responses = user.essay_responses.where(course_id: old_course.id)
    #essay_responses.update_all(course_id: new_course.id, tutor_id:  tutor_id)
    update_existing_essay_responses_expiry(essay_responses,course, tutor_id)
  end

  def transfer_purchase_addons_to_new_course old_enrolment
    features = old_enrolment.feature_logs.includes(purchase_item: :order).where(purchase_items: {purchasable_type: 'FeatureLog'}, orders: {status: 2})
    pt_feature = features.includes(:master_feature).where(" master_features.name ILIKE '%PrivateTutoringFeature%'").references(:master_features).first

    return unless pt_feature.present?
    private_tutor_enrolment = user.private_tutor_enrolment(course)

    if private_tutor_enrolment.present?
      total_qty = private_tutor_enrolment.qty + pt_feature.qty
      private_tutor_enrolment.update_attribute(:qty, total_qty)
    else
      non_fl = feature_logs.includes(product_version_feature_price: :master_feature).where("master_features.name ILIKE '%PrivateTutoringFeature%'").references(:product_version_feature_prices).first
      new_feature = feature_logs.where(qty: pt_feature.qty).includes(product_version_feature_price: :master_feature).where("product_version_feature_prices.is_additional = true AND master_features.name ILIKE '%PrivateTutoringFeature%'").references(:product_version_feature_prices).first

      unless new_feature.present?
        fl = feature_logs.includes(product_version_feature_price: :master_feature).where("product_version_feature_prices.is_additional = true AND master_features.name ILIKE '%PrivateTutoringFeature%'").references(:product_version_feature_prices).first
        new_feature = fl.update_attribute(:qty, pt_feature.qty) if fl
      end
      return unless new_feature.present?
      order = Order.create(user_id: user.id, creator_id: User.superadmin.first, status: :paid, purchase_method: :direct_deposit)

      new_feature.create_purchase_item(
        initial_cost: 0, user_id: user.id,
        purchase_description: new_feature.master_feature.title,
        order_id: order.id
      )

      if course_full?
        order.remove_purchase_items
        order.destroy!
      else
        order.complete_purchase(course)
      end
    end
  end

  def purchased_private_tutoring_session
    feature_logs.includes(:master_feature).where('feature_logs.acquired IS NOT NULL AND master_features.name LIKE (?)', '%PrivateTutoringFeature%').sum(:qty)
  end

  def purchased_private_tutoring_session_enrol
    feature_log = feature_logs.joins(:master_feature).where('feature_logs.acquired IS NOT NULL AND master_features.name LIKE (?)', '%PrivateTutoringFeature%').first
    # feature_log ||= feature_logs.joins(:master_feature).where('feature_logs.acquired IS NULL AND master_features.name LIKE (?)', '%PrivateTutoringFeature%').first
    return feature_log
  end

  def purchased_essays_session
    feature_logs.includes(:master_feature).where('feature_logs.acquired IS NOT NULL AND master_features.name LIKE (?)', '%EssayFeature%').sum(:qty)
  end

  def update_existing_essay_responses_expiry(essay_responses, new_course, tutor_id)
    unless essay_responses.blank?
      if new_course.expiry_date.present? && new_course.essay_exp_start_date.present? && new_course.expiry_date > new_course.essay_exp_start_date
        remaining_days = (course.expiry_date - course.essay_exp_start_date).to_i
      elsif new_course.expiry_date.present? && new_course.expiry_date > Date.today.next_month
        remaining_days = (new_course.expiry_date - Date.today.next_month).to_i
      else
        remaining_days = 365
      end
      if essay_responses.length == 1
        essay_responses_count = essay_responses.length
        interval = remaining_days
      else
        essay_responses_count = essay_responses.length
        interval = remaining_days/(essay_responses_count - 1)
      end
      essay_responses.order(:id).each_with_index do |ess_res, index|
        ess_res.update(course_id: new_course.id, tutor_id:  tutor_id)
      end
    end
  end

  private

  def enrol_features(old_enrolment=nil)
    pvpf_ids = []
    if course.product_version.slug.include?("custom")
      feature_logs.where(description: 'custom purchase').each { |f| f.activate(course, old_enrolment) }
      pvpf_ids = self.feature_logs.where(description: 'custom purchase').pluck(:product_version_feature_price_id)
    end

    self.course.product_version.product_version_feature_prices.where.not(id: pvpf_ids).where.not(is_additional: true).each do |pf|
      if pf.master_feature.textbook? && (self.hardcopy)
        acquired = !self.online_textbook ? nil : (pf.is_default ? DateTime.now : nil)
      else
        acquired = pf.is_default ? DateTime.now : nil
      end
      qty = pf.qty

      fe = pf.feature_logs.create(acquired: acquired, enrolment_id: self.id, qty: qty)

      #transfer old data to new data
      if old_enrolment.present?
        transfer_old_course_data_to_new_course(old_enrolment) if pf.master_feature.essay? && pf.is_default
        fe.assign_hours_if_pv_changed(old_enrolment.course.try(:id), user.private_tutor_time_left) if pf.master_feature.private_tutoring?
      else
        fe.assign_essays(false, self.course.product_version.id) if pf.master_feature.essay? && pf.is_default
      end
      fe.assign_mock_exam_essay if pf.master_feature.live_exam? && pf.is_default
    end
    transfer_purchase_addons_to_new_course(old_enrolment) if old_enrolment
  end

  def course_uniqueness
    if(user.present? && state != 'Unenrolled' && paid_at.present?)
      if(trial?)
        # Each student can have 1 trail course and 1 free study guide per product line
        if user.paid_enrolments.includes(course: :product_version).where.not(id: id).where(trial: true, product_versions: { product_line_id: course.product_version.product_line_id }).present?
          errors.add(:user, "can be enrolled only once in product line trial course.")
        end
      elsif(!trial? && user.paid_enrolments.where(trial: false, course_id: course_id).where.not(id: id).present?)
        errors.add(:course, "can be enrolled only once by a user")
      end
    end
  end

  def expire_trial_and_remove
    unless(trial?)
      user.paid_enrolments.where(trial: true).destroy_all if user.present?
    end
  end
end
