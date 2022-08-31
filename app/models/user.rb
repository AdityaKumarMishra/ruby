# == Schema Information
#
# Table name: users
#
#  id                     :integer          not null, primary key
#  email                  :string           default(""), not null
#  encrypted_password     :string           default(""), not null
#  reset_password_token   :string
#  reset_password_sent_at :datetime
#  remember_created_at    :datetime
#  sign_in_count          :integer          default(0), not null
#  current_sign_in_at     :datetime
#  last_sign_in_at        :datetime
#  current_sign_in_ip     :inet
#  last_sign_in_ip        :inet
#  confirmation_token     :string
#  confirmed_at           :datetime
#  confirmation_sent_at   :datetime
#  created_at             :datetime
#  updated_at             :datetime
#  first_name             :string
#  last_name              :string
#  username               :string
#  date_of_birth          :date
#  date_signed_up         :datetime
#  role                   :integer          default(0), not null
#  bio                    :text
#  profile_image          :string
#  slug                   :string
#

class User < ApplicationRecord
  extend FriendlyId
  ratyrate_rater
  # Include default devise modules. Others available are:
  # :lockable, :timeoutable and :omniauthable
  cattr_accessor :filter_params
  attr_accessor :signup_form_start_time, :signup_form_end_time

  devise :invitable, :database_authenticatable, :registerable,
      :recoverable, :rememberable, :trackable, :validatable
  devise :confirmable unless ENV['DEVISE_CONFIRMABLE'] == "false"
  devise :session_limitable unless ENV['RAILS_ENV'] == "stage"

  has_one :address, as: :addresable, dependent: :destroy
  has_one :questionnaire, dependent: :destroy
  has_many :tutor_answers, dependent: :nullify
  has_many :mcq_hours, dependent: :nullify
  has_many :student_questions, dependent: :nullify
  has_many :user_surveys, class_name: 'Surveys::UserSurvey', dependent: :destroy
  has_many :surveys, class_name: 'Surveys::Survey', through: :user_surveys
  has_many :survey_answers, class_name: 'Surveys::SurveyAnswer', dependent: :destroy
  has_and_belongs_to_many :tutors_class, join_table: 'tutors_classes', class_name: 'StudentClass'
  has_and_belongs_to_many :students_class, join_table: 'students_classes', class_name: 'StudentClass'
  has_and_belongs_to_many :course_versions, join_table: 'students_course_versions'
  has_many :mcq_stems_authored, class_name: 'McqStem', foreign_key: 'author_id' # ones person created
  has_many :mcq_stems_reviewed, class_name: 'McqStem', foreign_key: 'reviewer_id'# ones person reviewed
  has_many :stem_students, dependent: :destroy
  has_many :mcq_stems, through: :stem_students

  has_many :overseeings, dependent: :destroy
  has_many :overseeing_tags, through: :overseeings, source: 'tag'

  has_many :essay_responses, class_name: 'EssayResponse', foreign_key: 'user_id', dependent: :destroy


  # Not entirely sure invoices is ever used nor things relying on invoices
  has_many :invoices, dependent: :nullify
  has_many :invoice_specs, through: :invoices
  has_many :service_specs, through: :invoice_specs

  has_many :additional_essays, through: :service_specs
  has_many :additional_mcqs, through: :service_specs
  has_many :additional_appointments, through: :service_specs
  has_many :additional_exam, through: :service_specs

  has_one :tutor_profile, foreign_key: 'tutor_id', dependent: :destroy
  has_one :staff_profile, foreign_key: 'staff_id', dependent: :destroy

  has_many :appointments, class_name: 'Appointment', foreign_key: 'student_id', dependent: :destroy
  has_many :tutor_appointments, class_name: 'Appointment', foreign_key: 'tutor_id', dependent: :destroy

  has_many :documents, dependent: :destroy
  has_many :textbooks, dependent: :destroy
  has_many :textbook_prints
  has_many :access_documents, dependent: :destroy
  has_many :accessed_documents, through: :access_documents, source: 'document'

  has_many :exercises, dependent: :destroy
  has_many :attempted_mcqs, through: :exercises
  has_many :mcq_attempts, dependent: :destroy
  has_many :mcq_attempt_mcq_stems, -> { distinct }, through: :mcq_attempts, source: :mcq_stem
  has_many :mcq_attempt_mcqs, through: :mcq_attempts, source: :mcq
  has_many :mcq_attempt_answers, through: :mcq_attempts, source: :mcq_answer
  has_many :orders, dependent: :destroy
  has_many :purchase_items, through: :orders, dependent: :destroy
  has_many :enrolments, through: :purchase_items, source: :purchasable, source_type: 'Enrolment'
  has_many :courses, through: :enrolments
  has_many :product_versions, through: :courses
  has_many :tags, -> { distinct }, through: :product_versions
  has_many :vods, -> { distinct }, through: :tags
  has_many :accessible_mcq_stems, -> { uniq }, through: :tags, source: :mcq_stems
  has_many :accessible_mcqs, -> { uniq }, through: :accessible_mcq_stems, source: :mcqs
  has_many :mcq_statistics, dependent: :destroy
  has_many :exam_statistics, dependent: :destroy
  has_many :assessment_attempts, dependent: :destroy
  has_many :online_exam_attempts, -> { where assessable_type: 'OnlineExam' }, class_name: "AssessmentAttempt"
  has_many :online_mock_exam_attempts, -> { where assessable_type: 'OnlineMockExam' }, class_name: "AssessmentAttempt"
  has_many :diagnostic_test_attempts, -> { where assessable_type: 'DiagnosticTest' }, class_name: "AssessmentAttempt"
  has_many :section_attempts, through: :assessment_attempts
  has_many :section_item_attempts, through: :section_attempts

  has_many :tickets, foreign_key: 'asker_id', inverse_of: :asker, dependent: :destroy
  has_many :interaction_logs, foreign_key: 'asker_id', inverse_of: :asker, dependent: :destroy
  has_many :votes, dependent: :destroy
  has_many :out_of_stocks, dependent: :destroy
  has_many :textbook_deliveries, dependent: :destroy

  has_many :enrolments_paid, -> { where 'orders.status !=?', 0 }, source: 'purchasable', source_type: 'Enrolment', through: :purchase_items

  has_many :active_paid_courses, -> { where 'courses.expiry_date >= (?)', Date.today}, source: 'course', through: :enrolments_paid

  before_destroy :check_email_destroy, :delete_extra_questionnaire

  before_destroy do
    lost_tickets_user_id = User.find_by_username("lost.tickets")&.id
    if lost_tickets_user_id.present?
    # Reset to default user since answerer can't be null
      tickets.update_all(answerer_id: lost_tickets_user_id)
      Ticket.where(answerer: self).update_all(answerer_id: lost_tickets_user_id)
    end

    # Will be run even if user deletion fails. This is a rare enough case that has been deliberately ignored
  end

  has_many :ticket_answers, dependent: :destroy
  has_many :mock_essay_feedbacks, dependent: :destroy
  has_many :clarifications, class_name: 'Comment', foreign_key: 'user_id', dependent: :destroy
  has_many :transfer_transactions, dependent: :destroy
  has_many :watcheds, dependent: :destroy
  has_many :feature_logs, through: :enrolments
  has_many :product_version_feature_prices, through: :feature_logs
  has_many :master_features, through: :product_version_feature_prices
  has_many :tutor_schedules, through: :tutor_profile, dependent: :destroy
  has_many :live_exams, dependent: :destroy
  has_many :mock_exam_essays, dependent: :destroy
  has_many :user_announcements, dependent: :destroy
  has_many :promos, dependent: :destroy
  has_many :mail_pendings, dependent: :destroy
  has_many :exam_attempts, class_name: "OnlineExamAttempt", dependent: :destroy
  has_many :tutor_essay_responses, class_name: 'EssayResponse', foreign_key: 'tutor_id'
  belongs_to :active_course, foreign_key: 'active_course_id', class_name: 'Course', optional: true
  has_many :performance_stats, dependent: :destroy
  has_many :user_stats, dependent: :destroy
  has_many :textbook_reads, dependent: :destroy

  has_attached_file :photo,
                    styles: {small: '140x140#', standard: '200x200#', large: '500x500>'}
  validates_attachment_content_type :photo, content_type: /^image\/(png|gif|jpeg|jpg)/

  acts_as_commontator

  friendly_id :username, use: :slugged

  accepts_nested_attributes_for :tutor_profile, allow_destroy: true
  accepts_nested_attributes_for :staff_profile, allow_destroy: true
  accepts_nested_attributes_for :tags, allow_destroy: true

  accepts_nested_attributes_for :address, :questionnaire

  validates_numericality_of :appointment_length, less_than: 300
  # validates :phone_number, presence: true Jeremy Removed as hotfix as this as was causing issue ticketing system to not work,
  validates :email, presence: true, uniqueness: true, format: { with: /\A[\w+\-.]+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/i, message: 'Please enter a valid email address' }
  # validates :role, presence: true
  validates :phone_number, numericality: true, allow_nil: true
  validates_length_of :phone_number, minimum: 10, maximum: 15, allow_blank: true

  attr_accessor :remove_photo, :redirect_sign_up
  before_save :delete_photo, if: ->{ remove_photo == '1' && !photo_updated_at_changed? }
  before_destroy :mcq_reassign
  after_create :send_first_welcome_email
  has_one :order_creator, foreign_key: 'creator_id', class_name: 'Order'
  after_create :create_user_announcements

  # Stop devise from validating email since we do it ourselves
  validates :first_name, format: { with:  /\A[a-zA-Z._ ]+\z/ }, allow_nil: true
  validates :last_name, format: { with:  /\A[a-zA-Z._ ]+\z/ }, allow_nil: true

  def check_email_destroy
    user = ['tt@gradready.com.au', 'tm@gradready.com.au', 'ta@gradready.com.au', 'ts-sa@gradready.com.au']
    if user.include?(self.email)
      errors.add(:base, "Destroy aborted; you can't do that!")
      #return false //use throw(:abort for rails 6)
      throw(:abort)
    end
  end

  def delete_extra_questionnaire
    que = Questionnaire.where(user_id: id)
    que.destroy_all
  end

  def email_required?
    false
  end
  def email_changed?
    false
  end

  scope :without_course, -> { where('id NOT IN (SELECT DISTINCT user_id FROM students_course_versions)') }
  scope :for_subject, -> (_subject) { joins(:tutors_class).where }

  scope :all_staff, -> { where(role: 1..4).order(:first_name, :last_name) }
  enum role: [:student, :tutor, :manager, :admin, :superadmin]
  enum area: [:other, :victoria, :new_south_wales, :queensland, :australian_capital_territory, :south_australia, :northern_territory, :western_australia, :tasmania]

  filterrific(
    available_filters: [
      :sorted_by,
      :with_name,
      :with_role,
      :with_account_status,
      :with_specialty,
      :with_start,
      :with_start_not_student,
      :with_end,
      :with_end_not_student,
      :from_ticket_ans,
      :to_ticket_ans,
      :by_product_line,
      :by_enroled,
      :by_state,
      :by_product_version,
      :by_master_feature,
      :by_course,
      :by_subscription,
      :by_users,
      :answered_by,
      :by_courses_status,
      :with_start_purchase,
      :with_end_purchase,
      :option,
      :temporary_access
    ]
  )

  scope :answered_by, -> (answerer_id) { includes(:ticket_answers).where(ticket_answers: {user_id: answerer_id }) }
  scope :by_courses_status, -> (status){
    if status == 1 && filter_params.with_role == 0
      includes(enrolments: [:course]).where("DATE(courses.expiry_date) >= ? AND enrolments.state != 3", Date.today).references(enrolments: [:course])
    else
      all
    end
  }

  scope :by_subscription, -> (option){
    where(email_subscription: true)}
  scope :option, -> (opt) {includes(:textbook_deliveries).where('textbook_deliveries.status = ?', opt).references(:textbook_deliveries)}
  scope :temporary_access, -> (temp_access) { includes(:textbook_deliveries).where('textbook_deliveries.temporary_access_granted = ?', temp_access).references(:textbook_deliveries) if temp_access == "true"}
  scope :sorted_by, -> (sort_key){ order "users." + sort_key }
  enum status: [:activated, :deactivated]
  scope :with_name, -> (name){ where "first_name ILIKE :name OR last_name ILIKE :name OR first_name ||' '|| last_name ILIKE :name OR last_name ||' '|| first_name ILIKE :name OR username ILIKE :name OR email ILIKE :name OR username ||' '|| email ILIKE :name OR email ||' '|| username ILIKE :name OR phone_number ILIKE :name", name: "%#{name}%" }
  scope :with_role, -> (role){ where(role: role)}
  scope :with_account_status, -> (account_status) { where(status: account_status) }
  scope :with_specialty, ->(specialty) do
    if specialty == 'GC Tutor'
      includes(:tutor_profile).where("role != 0 AND tutor_profiles.issue_ticket = true").references(:tutor_profile)
    elsif specialty == 'Private Tutor'
      includes(:tutor_profile).where("role != 0 AND tutor_profiles.private_tutor = true").references(:tutor_profile)
    elsif specialty == 'Essay Marker'
      if filter_params&.by_courses_status&.to_i == 1
        includes(staff_profile: [:courses]).where("role != 0 AND staff_profiles.id IS NOT NULL AND courses.id IN (?)", Course.active_courses.ids).references(staff_profile: [:courses])
      else
        includes(staff_profile: [:courses]).where("role != 0 AND staff_profiles.id IS NOT NULL AND courses.id IS NOT NULL").references(staff_profile: [:courses])    
      end
    else
      self.all
    end
  end

  def specialty
    specialties = []
    specialties.push('Essay Marker') if staff_profile.present?
    specialties.push('Private Tutor') if tutor_profile.present? && tutor_profile.private_tutor
    specialties.push('GC Tutor') if tutor_profile.present? && tutor_profile.issue_ticket

    specialties.join('/').presence || 'NA'
  end

  scope :with_start, -> (with_start) do
    begin
      DateTime.parse with_start
      joins(:enrolments).where("(enrolments.paid_at IS NOT NULL AND enrolments.paid_at >= ? )", with_start).references(:enrolments)
    rescue ArgumentError
    end
  end

  scope :with_end, -> (with_end) do
    begin
      DateTime.parse with_end
      joins(:enrolments).where("(enrolments.paid_at IS NOT NULL AND enrolments.created_at <= ? )", with_end).references(:enrolments)
    rescue ArgumentError
    end
  end

  scope :with_start_purchase, -> (with_start_purchase) do
    begin
      DateTime.parse with_start_purchase
      joins(:purchase_items).where("purchase_items.id in (SELECT DISTINCT ON (user_id) max(id) id FROM purchase_items WHERE purchasable_type = 'Enrolment' GROUP BY purchase_items.user_id) AND DATE(purchase_items.created_at) >= ?", with_start_purchase.to_date)
    rescue ArgumentError
    end
  end

  scope :with_end_purchase, -> (with_end_purchase) do
    begin
      DateTime.parse with_end_purchase
      joins(:purchase_items).where("purchase_items.id in (SELECT DISTINCT ON (user_id) max(id) id FROM purchase_items WHERE purchasable_type = 'Enrolment' GROUP BY purchase_items.user_id) AND DATE(purchase_items.created_at) <= ?", with_end_purchase.to_date)
    rescue ArgumentError
    end
  end

  scope :from_ticket_ans, -> (from_ticket_ans) do
    includes(:ticket_answers).where('ticket_answers.created_at >= ?', from_ticket_ans).references(:ticket_answers)
  end
  scope :to_ticket_ans, -> (to_ticket_ans) do
    includes(:ticket_answers).where('ticket_answers.created_at <= ?', to_ticket_ans).references(:ticket_answers)
  end

  # TODO: we need to add ProductLine model which will stand for gamsat, umat, etc. to make correct relations for filters
  # ugly scope because of above comment
  scope :by_product_line, -> (product_line) { joins(:product_versions).where(product_versions: { id: ProductVersion.where('type like ?', "#{product_line}%") }) }

  scope :by_product_version, -> (pv_id)  do
    pv_id = pv_id&.reject(&:blank?)
    return all if pv_id.blank?

    order_statuses = [2, 1, 0, 3]
    or_status = nil
    or_status = order_statuses[filter_params.by_enroled] if filter_params&.by_enroled.present?

    if filter_params.present? && filter_params.by_courses_status == 1 && or_status.present?
      includes(enrolments: [:course, :order]).where("enrolments.state != 3 AND orders.status = ? AND courses.product_version_id IN (?) AND courses.expiry_date >= ?", or_status, pv_id, Date.today).references(enrolments: [:course, :order])
    elsif filter_params.present? && filter_params.by_courses_status == 1 && or_status.nil?
      includes(enrolments: [:course]).where("enrolments.state != 3 AND courses.product_version_id IN (?) AND courses.expiry_date >= ?", pv_id, Date.today).references(enrolments: [:course])
    else
      joins(:product_versions).where(product_versions: { id: pv_id })
    end
  end

  scope :by_course, -> (course_id) { includes(:courses).where(courses: { id: course_id }) }

  scope :by_master_feature, -> (mf_id) do
    filter_params.by_product_version = filter_params.by_product_version&.reject(&:blank?) if filter_params.present?
    mf_id = mf_id&.reject(&:blank?)
    return all if mf_id.blank?

    order_statuses = [2, 1, 0, 3]
    or_status = nil
    or_status = order_statuses[filter_params.by_enroled] if filter_params&.by_enroled.present?

    if filter_params.present?
      if filter_params.by_product_version.present?
        if filter_params.by_courses_status == 1 && or_status.present?
          joins(feature_logs: [:master_feature, course: :enrolments]).where('master_features.id IN (?) AND feature_logs.acquired IS NOT NULL AND courses.expiry_date >= (?) AND courses.product_version_id IN (?) AND orders.status = ?', mf_id, Date.today, filter_params.by_product_version, or_status).references(:feature_logs).distinct
        elsif filter_params.by_courses_status == 1 && filter_params.by_enroled.nil?
          joins(feature_logs: [:master_feature, course: :enrolments]).where('master_features.id IN (?) AND feature_logs.acquired IS NOT NULL AND courses.expiry_date >= (?) AND courses.product_version_id IN (?)', mf_id, Date.today, filter_params.by_product_version).references(:feature_logs).distinct
        elsif filter_params.by_courses_status == 0 && or_status.present?
          joins(feature_logs: [:master_feature, course: :enrolments]).where('master_features.id IN (?) AND courses.product_version_id IN (?) AND feature_logs.acquired IS NOT NULL AND orders.status = ?', mf_id, filter_params.by_product_version, or_status).references(:feature_logs).distinct
        elsif filter_params.by_courses_status == 0 && filter_params.by_enroled.nil?
          joins(feature_logs: [master_feature: :product_version_feature_prices, course: :enrolments]).where('master_features.id IN (?) AND feature_logs.acquired IS NOT NULL AND courses.product_version_id IN (?)', mf_id, filter_params.by_product_version).references(:feature_logs).distinct
        end
      else
        if filter_params.by_courses_status == 1 && or_status.present?
          joins(feature_logs: [:course, :product_version_feature_price]).where("feature_logs.acquired IS NOT NULL AND product_version_feature_prices.master_feature_id IN (?) AND orders.status = (?) AND courses.expiry_date >= (?)", mf_id, or_status, Date.today).references(:feature_logs).distinct
        elsif filter_params.by_courses_status == 1 && filter_params.by_enroled.nil?
          joins(feature_logs: [:course, :product_version_feature_price]).where('feature_logs.acquired IS NOT NULL AND product_version_feature_prices.master_feature_id IN (?) AND courses.expiry_date >= (?)', mf_id, Date.today).references(:feature_logs).distinct
        elsif filter_params.by_courses_status == 0 && or_status.present?
          joins(feature_logs: [:course, :product_version_feature_price]).where('feature_logs.acquired IS NOT NULL AND product_version_feature_prices.master_feature_id IN (?) AND orders.status = (?)', mf_id, or_status).references(:feature_logs).distinct
        elsif filter_params.by_courses_status == 0 && filter_params.by_enroled.nil?
          joins(feature_logs: [:course, :product_version_feature_price]).where('feature_logs.acquired IS NOT NULL AND product_version_feature_prices.master_feature_id IN (?)', mf_id).references(:feature_logs).distinct
        end
      end
    else
      joins(:courses, feature_logs: [:master_feature]).where.not(feature_logs: { acquired: nil }).where('master_features.id IN (?) AND orders.status != (?)', mf_id, 0).references(:feature_logs).distinct
    end
  end

  scope :paid, -> {
    includes(purchase_items: :order).where("orders.status IN (2)").references(:purchase_items)
  }

  scope :dd_incomplete, -> {
    includes(purchase_items: :order).where("orders.status IN (1)").references(:purchase_items)
  }

  scope :checkout_incomplete, -> {
    includes(purchase_items: :order).where("orders.status IN (0)").references(:purchase_items)
  }

  scope :free_trial, -> {
    includes(purchase_items: :order).where("orders.status IN (3)").references(:purchase_items)
  }

  scope :by_enroled, -> (enroled) {
    if enroled.to_i == 0
      paid
    elsif enroled.to_i == 1
      dd_incomplete
    elsif enroled.to_i == 2
      checkout_incomplete
    elsif enroled.to_i == 3
      free_trial
    elsif enroled.to_i == 4
      where(confirmed_at: nil)
    else
      all
    end
  }


  scope :by_users, -> (optn) {
    if optn.to_i == 0
      EnquiryUser.all
    else
      User.all
    end
  }

  scope :enroled, -> { includes(purchase_items: :order).where("purchase_items.purchasable_type = 'Enrolment' AND orders.status !=? AND orders.status !=?", 0, 1).references(:purchase_items) }

  scope :not_enroled, -> { where.not(id: PurchaseItem.pluck(:user_id)) }

  scope :by_state, -> (state) do
    state = state&.reject(&:blank?)
    return all if state.blank?

    order_statuses = [2, 1, 0, 3]
    or_status = nil
    or_status = order_statuses[filter_params.by_enroled] if filter_params&.by_enroled.present?

    if filter_params.present? && filter_params.by_courses_status == 1 && or_status.present?
      includes(enrolments: [:course, :order]).where('courses.expiry_date >= ? AND enrolments.state != 3 AND courses.city IN (?) AND orders.status = ?', Date.today, state, or_status).references(enrolments: [:course, :order])
    elsif filter_params.present? && filter_params.by_courses_status == 1 && or_status.nil?
      includes(enrolments: [:course]).where('courses.expiry_date >= ? AND enrolments.state != 3 AND courses.city IN (?)', Date.today, state).references(enrolments: [:course])
    else
      includes(:courses).where(courses: { city: state })
    end
  end

  delegate :state, :line_one, :line_two, :suburb, :post_code, :country, to: :address, allow_nil: true
  delegate :source, :last_source, :student_level, :highschool_year_level, :target_uni_course,
           :current_highschool, :university, :degree, to: :questionnaire, allow_nil: true
  # Don't let users log in as anonymous/temporary users
  # def active_for_authentication?
  #   super
  # end

  def upgraded_user?
    orders.includes(:purchase_items).where("orders.status NOT IN (0, 1) AND (purchase_items.initial_cost > 0)").references(:purchase_items).present? ? true : false
    # User.by_enroled("1").include?(self) ? true : false
  end

  def enrolled_course_ids
    courses.includes(:enrolments).where("enrolments.state != 3 AND enrolments.id IN (?)", enrolments.pluck(:id)).references(:enrolments).pluck(:id)
  end

  def paid_enrolments
    enrolments.where("orders.status !=? AND orders.status !=?", 0, 1).references(:orders)
  end

  def paid_with_pending_enrolments
    enrolments.where("orders.status !=?", 0).references(:orders)
  end

  def paid_courses
    custom_enrolment = orders.where(status: :registered).first&.purchase_items&.first&.purchasable_id
    custom_fls = []

    custom_fls = FeatureLog.includes(purchase_item: :order).where("purchase_items.order_id in (?) AND enrolment_id = ?", orders.ids, custom_enrolment).references(:purchase_item) if custom_enrolment.present?
    order_status_arr = custom_fls.present? ? [2, 3, 4, 5, 6] : [2, 3, 4, 5]

    courses.where("orders.user_id = ? AND orders.status IN (?)", id, order_status_arr).references(:orders)
  end

  def user_email_enroled
    enroled = true
    trial_enrolments_count = paid_enrolments.where(trial: true).count
    paid_enrolments_count = paid_enrolments.count
    if paid_enrolments_count == 0 || trial_enrolments_count == paid_enrolments_count
      enroled = false
    end
    enroled
  end


  def feature_tag_ids feature_name
   pvfp = product_version_feature_prices.where(id: feature_logs.includes(:product_version_feature_price).includes(enrolment: :course).where("acquired IS NOT NULL AND (enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND courses.expiry_date >= ?", false, true, Time.zone.now, Time.zone.today).references(:course).pluck(:product_version_feature_price_id)).includes(:master_feature).where(" master_features.name LIKE ?" , "%#{feature_name}%").references(:master_features).first
    if pvfp
      pvfp.tags.map(&:self_and_descendants).flatten.sort_by(&:name)
    else
      Tag.none
    end
  end

  def student_subject_performance(tag, values, user_id)

    user = User.find(user_id)
    if values.klass == Vod
      if tag.children.present?
        v_ids_count = values.by_decendent_tag(tag).pluck(:id).uniq.count
        user_count = user.performance_stats.performable_type("Vod").tag_filter(tag.self_and_descendants_ids).count
        res = (user_count.to_f / v_ids_count) * 100
        result = res.round(2)
      else
        v_ids = values.by_tag(tag).pluck(:id).uniq
        if v_ids.present?
          total_count = v_ids.count
          user_count = user.performance_stats.performable_type("Vod").tag_filter(tag.id).count
          res = (user_count.to_f / total_count) * 100
          result = res.round(2)
        else
          result = 0
        end

      end

      result
    else
      if tag.children.present?
        t_ids_count = values.with_tags(tag.id).pluck(:id).uniq.count
        user_count = user.performance_stats.performable_type("Textbook").tag_filter(tag.self_and_descendants_ids).count
        res = (user_count.to_f / t_ids_count) * 100
        result = res.round(2)
      else
        t_ids = values.by_tags(tag.id).pluck(:id).uniq
        total_count = t_ids.count
        user_count = user.performance_stats.performable_type("Textbook").tag_filter(tag.id).count
        res = (user_count.to_f / total_count) * 100
        result = res.round(2)

      end

      result
    end

  end

  def avg_subject_performance(tag, values)
    if values.klass == Vod
      users = PerformanceStat.where(performable_type: "Vod").tag_filter(tag.self_and_descendants_ids).pluck(:user_id).uniq
      if users.present?
        a = []
        users.each do |id|
          a << student_subject_performance(tag, values, id)
        end
        result = a.inject(0){|sum,x| sum + x } / a.count
        result.round(2)
      else
        0
      end
    else
      users = PerformanceStat.where(performable_type: "Textbook").tag_filter(tag.self_and_descendants_ids).pluck(:user_id).uniq
      if users.present?
        b = []
        users.each do |id|
          b << student_subject_performance(tag, values, id)
        end
        result = b.inject(0){|sum,x| sum + x } / b.count
        result.round(2)
      else
        0
      end
    end
  end

  def product_version_feature_logs
    feature_logs.includes(:product_version_feature_price).where(product_version_feature_prices: { product_version_id: active_course.try(:product_version_id) })
  end

  def has_only_expired_course?
    (paid_enrolments.count == 1) && ((paid_enrolments.first.trial? && paid_enrolments.first.trial_expired?) || paid_enrolments.first.course.expired?)
  end

  def self.options_for_sorted_by
    [
      ['Name (a-z)', 'first_name asc'],
      # ['Last Name (a-z)', 'last_name asc'],
      ['Registration date (newest first)', 'created_at desc'],
      ['Registration date (oldest first)', 'created_at asc']
    ]
  end

  def options_for_role
    if self.superadmin?
      [["Admin", 3], ["Manager", 2], ["Student", 0], ["SuperAdmin", 4], ["Tutor", 1] ]
    elsif self.admin?
      [["Admin", 3], ["Manager", 2], ["Student", 0], ["Tutor", 1]]
    elsif self.manager?
      [["Manager", 2], ["Student", 0], ["Tutor", 1]]
    elsif self.tutor?
      [["Student", 0], ["Tutor", 1]]
    end

  end

  def tags
    tags_with_decedants = []
    super.each do |tag|
      unless tags_with_decedants.include?(tag)
        tags_with_decedants += tag.self_and_descendants
      end
    end
    tags_with_decedants.uniq.sort_by{|tag| tag.name.upcase}
  end

  def all_tags
    self.tags.map(&:name).join(", ")
  end


  def overdue_count(tickets)

    tickets = tickets.answerer_filter(self.id)

    overdue_ticket_responses= []

    tickets.unanswered.each do |ticket|

      if ticket.created_at.wday == 5 || ticket.created_at.wday == 6 || ticket.created_at.wday == 0
        check_hours = ticket.not_count_weekends(24)
        if (ticket.created_hours >= check_hours)
            overdue_ticket_responses << ticket
        end
      else
        if (ticket.created_hours >= 24)
            overdue_ticket_responses << ticket
        end
      end
    end

    tickets.each do |ticket|
      if ticket.ticket_answers.present?
        if ticket.created_at.wday == 5 || ticket.created_at.wday == 6 || ticket.created_at.wday == 0
          check_hours = ticket.not_count_weekends(24)
          if (ticket.created_hours >= ticket.ticket_answers.first.created_hours + check_hours)
              overdue_ticket_responses << ticket
          end
        else
          if (ticket.created_hours >= ticket.ticket_answers.first.created_hours + 24)
              overdue_ticket_responses << ticket
          end
        end
      end
    end

    tickets.where(status: 2).each do |ticket|
      if ticket.follow_up_date.present?
        if ticket.created_at.wday == 5 || ticket.created_at.wday == 6 || ticket.created_at.wday == 0
          check_hours = ticket.not_count_weekends(72)
          if (ticket.follow_up_hours >= check_hours)
              overdue_ticket_responses << ticket
          end
        else
          if (ticket.follow_up_hours >= 72)
              overdue_ticket_responses << ticket
          end
        end
      end
    end

    overdue_ticket_responses.uniq.count
  end

  def ticket_answer_count(tickets)
    tickets.answerer_filter(self.id).count
  end

  def feedback_ticket_count(tickets)
    tickets.answerer_filter(self.id).feedback_filter('Yes').count
  end

  def complaint_ticket_count(tickets)
    tickets.answerer_filter(self.id).complaint_filter(true).count
  end

  def marked_essays_count
    staff_id=StaffProfile.where("staff_id=?", self.id).ids
    responses_count = EssayResponse.includes(:essay_tutor_response, :essay).where('(time_submited is not ?) AND (essay_tutor_responses.id is not ?) AND essay_tutor_responses.staff_profile_id IN (?) ', nil, nil, staff_id).references(:essay_tutor_responses).count
    return responses_count
  end

  def root_tags
    # Returns the root of all tags that user has access to (assigned + public)
    tags_available = policy_scope(Tag).sort_by{|tag| tag.name.upcase}
    tag_ids = tags_available.map{|tag| tag.id}
    tags_available.select{|tag| tag.parent.nil? || !tag_ids.include?(tag.id)}
  end

  def remove_duplicate_essays_if_any(course)
    essay_responses.where(course_id: course.id).to_a.group_by(&:essay_id).each do |essay_id, essay_responses|
      next if essay_responses.size < 2

      essay_responses.sort_by(&:created_at)[1..-1]&.map(&:destroy)
    end
  end

  def validate_essay_numbers
    #Checks whether the student has all the essay responses they should have
    f_logs = product_version_feature_logs.where.not(acquired: nil)
    essay_num = f_logs.eager_load(:master_feature).collect{|fl| fl.qty if fl.master_feature.essay? }.compact.sum
    f_logs.eager_load(:master_feature, :enrolment, product_version_feature_price: :tags)
      .where('feature_logs.qty IS NOT NULL and feature_logs.qty > 0')
      .select{|fl| fl.master_feature.essay? }.each do |fl|
      if fl.active? && fl.enrolment.present? && active_course.essay_responses.where(user_id: self.id).count < essay_num
        tag_list = fl.product_version_feature_price.tags.compact.map(&:self_and_descendants).flatten.compact
        responses = active_course.essay_responses.where(user_id: self.id).includes(essay: :tags).where('tags.id in (?)', tag_list.map(&:id)).references(:tags)
        fl.assign_essays(false, fl.product_version.id) unless responses.present?
      elsif fl.active? && fl.enrolment.present? && active_course.essay_responses.where(user_id: self.id).count > essay_num
        delete_response_count = active_course.essay_responses.where(user_id: self.id,assessment_attempt_id: nil).count - essay_num
        extra_responses = active_course.essay_responses.where(user_id: self.id, time_submited: nil).limit(delete_response_count)
        extra_responses.destroy_all
      end
    end
  end

  def vods
    videos = []
    tags.each do |tag|
      videos += tag.vods
    end
    videos.uniq
  end

  def tutor_tags
    tutor_profile.tags
  end

  def staff_tags
    staff_profile.tags
  end

  def access_features(course)
     master_feature_ids = active_en_features(course).includes(:product_version_feature_price).references(:product_version_feature_price).pluck("product_version_feature_prices.master_feature_id")
    MasterFeature.where(id: master_feature_ids)
  end

  def active_en_features(course)
    pv_logs(course).includes(enrolment: :course).where("acquired IS NOT NULL AND (enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND courses.expiry_date >= ? AND courses.id = ?", false, true, Time.zone.now, Time.zone.today.beginning_of_day, course.try(:id)).references(:course)
  end

  def pv_logs(course)
    feature_logs.includes(:product_version_feature_price).where(product_version_feature_prices: { product_version_id: course.try(:product_version_id) })
  end

  def accessible_features
    master_feature_ids = active_enrolment_features.includes(:product_version_feature_price).references(:product_version_feature_price).pluck("product_version_feature_prices.master_feature_id")
    MasterFeature.where(id: master_feature_ids)
  end

  def accessibile_feature_names
    accessible_features.pluck(:name).compact.uniq.reject(&:blank?)
  end

  def active_enrolment_features
    all_feature_logs = product_version_feature_logs.includes(enrolment: :course).where("(enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND courses.expiry_date >= ? AND courses.id = ?", false, true, Time.zone.now, Time.zone.today.beginning_of_day, active_course.try(:id)).references(:course)
    acquired_feature_logs = all_feature_logs.where("acquired IS NOT NULL")
    not_acquired_feature_logs = all_feature_logs.where("acquired IS NULL")
    unless active_course.nil?
      if active_course.product_version.custom?
        not_acquired_vid_feature_log = not_acquired_feature_logs.joins(:master_feature).where("master_features.name ILIKE (?)", "%video%")
        if not_acquired_vid_feature_log.present? && acquired_feature_logs.joins(:master_feature).where("master_features.name ILIKE (?) OR master_features.name ILIKE (?)", "%livemockexam%", "%onlinemockexam%").present?
          acquired_feature_logs = all_feature_logs.where(id: (acquired_feature_logs + not_acquired_vid_feature_log).map(&:id))
        end
      end
    end
    return acquired_feature_logs
  end

  def not_vid_featue_log?
   product_version_feature_logs.includes(:master_feature, enrolment: :course).where("acquired IS NOT NULL AND (enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?)) AND courses.expiry_date >= ? AND courses.id = ? AND master_features.name ILIKE (?)", false, true, Time.zone.now, Time.zone.today.beginning_of_day, active_course.try(:id), "%video%").references(:course).blank? && active_course.product_version.custom?
  end

  def accessible_tags
    active_feature_tags.values.flatten
  end

  def current_course_tags
    if active_course
      active_course.tags_cache
    else
      Tag.none
    end
  end

  def current_product_verion_feature_price feature_name, check_tags = false
    pvfps = active_product_version_feature_prices.includes(:master_feature).where(" master_features.name LIKE ?" , "%#{feature_name}%").references(:master_features)

    if check_tags
      pvfps = pvfps.select{ |pvfp| pvfp.tags.present? }
    end

    pvfps.last
  end

  def current_feature_tags feature_name
    pvfp = current_product_verion_feature_price(feature_name, feature_name.include?('ExamFeature') ? true : false)
    if pvfp
      Rails.cache.fetch("pvfp-#{cache_key}/tags", expires_in: 0.hour) do
        pvfp.tags.map(&:self_and_descendants).flatten.sort_by(&:name)
      end
    else
      Tag.none
    end
  end

  def current_product_verion_feature_price_tags feature_name
    if student?
      pvfp = current_product_verion_feature_price(feature_name)
      pvfp.present? ? pvfp.tags.map(&:children).flatten.sort_by(&:name) : Tag.none
    else
      Tag.order(:name)
    end
  end

  def active_product_version_feature_prices
    product_version_feature_prices.where(id: active_enrolment_features.pluck(:product_version_feature_price_id))
  end

  def children_course_tags
    Tag.where(id: current_course_tags.collect{ |current_course_tag|
      current_course_tag.self_and_descendants_ids}.flatten.uniq)
  end

  # Find all tags that the user has for the given model, by going through all their
  # features and selecting the ones that are relevant to the model
  def tags_for_model(model)
    model_symbol = model.name.underscore
    feature_logs_array = active_enrolment_features.select do |fl|
      next if fl.master_feature.nil?
      fl.master_feature.model_permissions.include? model_symbol
    end

    feature_logs_array.map { |fl| fl.product_version_feature_price.tags.flatten.map { |tag| tag.self_and_descendants } }.flatten
  end

  def unactive_enrolment_features
    # feature_enrolments.where(active: false)
  end

  def active_feature_tags
    out = {}
    active_enrolment_features.each do |f|
      out[f.master_feature.name.to_sym] ||= []
      f.tags.to_a.each do |tag|
        out[f.master_feature.name.to_sym].push(*tag.self_and_descendants).uniq!
      end
    end
    out
  end

  # once multiple enrolments are fully supported this should act as a switch between current enrolments
  def current_enrolment
    self.enrolments.last
  end

  def current_hardcopy_enrolment
    hard_copy_feature = self.accessible_features.find_by('name LIKE?', '%GamsatTextbookHardCopyFeature%')
    if hard_copy_feature.present?
      enrol = self.active_enrolment_features.first.enrolment
      enrol.update(hardcopy: true) if enrol.present?
    end
    self.enrolments.where(hardcopy: true).where.not(paid_at: nil).last
  end

  def average_number_of_time_logged_in_per_day
    if created_at.today?
      sign_in_count.to_f
    else
      (sign_in_count.to_f / (Date.today - created_at.to_date).to_f).round(2)
    end
  end

  def average_number_of_minutes_spend_per_day
    if created_at.today?
      total_online_time.to_f
    else
      (total_online_time.to_f / (Date.today - created_at.to_date).to_f).round(2)
    end
  end

  # Time calculations for paid enrolment of user for xlsx file

  def since_enrolment_average_number_of_time_logged_in_per_day
    all_enrol = enrolments.where(trial: false).pluck(:signin_count_enrolment)
    first_paid_enrol = enrolments.where(trial: false).first
    if all_enrol.present?
      login_count = sign_in_count - (all_enrol.sum / (all_enrol.count.to_f.nonzero? || 1 )).to_f
      if first_paid_enrol.created_at.today?
        login_count.to_f
      else
        (login_count.to_f / (Date.today - first_paid_enrol.created_at.to_date).to_f).round(3)
      end
    end
  end

  def since_enrolment_average_number_of_minutes_spend_per_day
    all_online_time = enrolments.where(trial: false).pluck(:total_online_time_enrolment)
    first_paid_enrol = enrolments.where(trial: false).first
    if all_online_time.present?
      total_time = total_online_time - (all_online_time.compact.sum / all_online_time.count.to_f.nonzero? || 1 ).to_f
      if first_paid_enrol.created_at.today?
        total_time.to_f
      else
        (total_time.to_f / (Date.today - first_paid_enrol.created_at.to_date).to_f).round(3)
      end
    end
  end

  def sign_in_count_from_enrolment
    all_enrol = enrolments.where(trial: false).pluck(:signin_count_enrolment)
    if all_enrol.present?
      total_signin_enrol = (all_enrol.sum / all_enrol.count.to_f.nonzero? || 1 ).to_f
      (sign_in_count - total_signin_enrol).to_f
    end
  end

  def total_online_time_from_enrolment
    all_online_time = enrolments.where(trial: false).pluck(:total_online_time_enrolment)
    if all_online_time.present?
      total_time = (all_online_time.sum / all_online_time.count.to_f.nonzero? || 1 ).to_f
      (total_online_time - total_time).to_f
    end
  end

  # Returns a list of answerers for the given content, using tags to join them (see Tag #answerers for details)
  def self.answerers_for_content(content)
    if content.present?
      if content.try(:staff_profile)
        [content.staff_profile.staff]
      else
        if content.class.name == "Mcq" && content.tag.nil?
          content.update_tag
        end
        content.tags.map { |tag| tag.answerers || [] }.flatten.uniq
      end
    end
  end

  def self.options_for_select_by_subject(subject_id = nil)
    tutors = []
    unless subject_id && !subject_id.empty?
      tutors = all
    else
      subjects = ActiveSubject.where subject_id: subject_id
      if subjects.any?
        subjects.each do |subject|
          tutors += subject.tutors
        end
      end
    end
    tutors.uniq.sort_by(&:to_s).map { |e| [e.to_s, e.id] }
  end

  def current_course
    course_versions.active.first.course if course_versions.active.any?
  end

  def product_purchased?(product)
    invoice_specs.where(product: product).any?
  end

  def roles_able_to_create
    all_roles = User.roles.keys
    if self.superadmin?
      return all_roles
    elsif self.admin?
      return all_roles - %w{superadmin}
    elsif self.manager?
      return all_roles - %w{admin superadmin}
    elsif self.tutor?
      return all_roles - %w{admin superadmin manager}
    else
      return nil
    end
  end

  # def mcqs
  #   additional_mcqs
  # end

  def essays
    additional_essays
  end

  def exams
    students_class.map do |studen_class|
      studen_class.subject.exam if studen_class.subject && studen_class.subject.exam
    end
  end

  def self.send_features_mail
    User.all.each do |user|
      if user.first_enrolment_date && (user.first_enrolment_date + 7.days).today?
        UserMailer.feature_auto_email(user).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
      end
    end
  end


  def full_name
    "#{first_name} #{last_name}"
  end

  def dashboard_courses
    course_versions.active
  end

  def to_s
    full_name
  end

  def self.active_tutors(params, places)
    return User.tutor if params == 'All'
    places.each do |p|
      return User.return_tutors(p) if params == p
    end
  end

  def answered_questions
    mcq_student_answers.map(:mcq)
  end

  def dashboard_surveys
    if surveys.any?
      return surveys.active.reject { |survey| survey.is_submited? self }
    end
    []
  end

  def dashboard_essays
    student_essays.active
  end

  def moderator?(tutor = nil)
    if tutor.nil?
      case role.to_sym
        when :student
          false
        when :tutor
          false
        else
          true
      end
    else
      case role.to_sym
        when :student
          false
        else
          true
      end
    end
  end

  def is_enrolled_in_course
    course_versions.each do |course_version|
      return true if course_version.course.is_active
    end
    false
  end

  alias is_enrolled_in_course? is_enrolled_in_course

  def self.options_for_tutor_admin_filter
    User.where.not(role: 0).order('LOWER(first_name), LOWER(last_name)').map { |e| [e.full_name, e.id] }
  end

  def self.options_for_tutor_filter_select
    User.tutor.order('LOWER(first_name), LOWER(last_name)').map { |e| [e.full_name, e.id] }
  end

  def self.options_for_staff_filter_select
    User.staff.order('LOWER(first_name), LOWER(last_name)').map { |e| [e.full_name, e.id] }
  end

  def self.return_tutors(city)
    User.tutor.includes(:addresses).where(addresses: {city: city})
  end

  def self.options_for_non_student_select
    User.where.not(role: 0).order('LOWER(first_name), LOWER(last_name)').map { |e| [e.full_name, e.id] }
  end

  def private_tutor?
    true if tutor_profile && tutor_profile.private_tutor
  end

  def invite?(current_user, role)
    #authenticate_user!(:force => true)
    if current_user.tutor? || current_user.student?
      return role=='student'
    elsif current_user.manager?
      return role!='admin' && role!='superadmin'
    elsif current_user.admin?
      return role!='superadmin'
    elsif current_user.superadmin?
      true
    else
      false
    end

  end

  def mcq_reassign
    mcq_stems_authored.each do |mcq_authored|
      mcq_authored.update(author: User.where(role:"superadmin").first)
    end
    mcq_stems_reviewed.each do |mcq_reviewed|
      mcq_reviewed.update(reviewer: User.where(role:"superadmin").first)
    end
  end

  def purchased_addons
    enrolments.includes(feature_logs: [purchase_item:
     [:order]]).map {|e| e.feature_logs}.flatten.compact.
      select{|f| f.active? && f.purchase_item.present? && f.purchase_item.order.paid?}
  end

  def validate_tutor_profile
    self.create_tutor_profile if self.tutor_profile.nil?
  end

  def validate_staff_profile
    self.create_staff_profile! if self.staff_profile.nil? && (self.tutor? || self.moderator?)
    #self.build_staff_profile if self.staff_profile.nil?
  end

  def validate_user_address
    self.create_address if self.address.nil?
  end

  # changed for GRAD-2841 selecting the course passed in arguments
  def private_tutor_time_left(with_start = nil, with_end = nil)
    # fe = private_tutor_enrolment(active_course)
    # (fe.present? && fe.qty) ? fe.qty : 0
    fe = private_tutor_enrolment_all(active_course, with_start, with_end)
    fe.map(&:qty).compact.sum
  end

  # changed for GRAD-2841 selecting the course passed in arguments (activate feature_log.rb)
  def private_tutor_enrolment_all(course=nil, with_start = nil, with_end = nil)
    act_course = course
    if act_course.blank?
      act_course = active_course ? active_course : course
      self.active_course = act_course
    end
    if current_enrolment
      pvfls = product_version_feature_logs
      pvfls = pvfls.where('DATE(feature_logs.created_at) >= ?', with_start.to_date) if with_start.present?
      pvfls = pvfls.where('DATE(feature_logs.created_at) <= ?', with_end.to_date) if with_end.present?
      pvfls.includes(:master_feature, :course).where("acquired IS NOT NULL AND master_features.name ILIKE '%PrivateTutoringFeature%' AND courses.id = ?", act_course.try(:id)).references(:master_features)
    end
  end

  # changed for GRAD-2841 selecting the course passed in arguments (deactivate feature_log.rb)
  def private_tutor_enrolment_course(course=nil)
    act_course = course
    if act_course.blank?
      act_course = active_course ? active_course : course
      self.active_course = act_course
    end
    if current_enrolment
      product_version_feature_logs.includes(:master_feature, :course).where("acquired IS NOT NULL AND master_features.name ILIKE '%PrivateTutoringFeature%' AND courses.id = ?", act_course.try(:id)).references(:master_features).first
    end
  end

  # old method for feature_log.rb activate not in user for GRAD-2841
  def private_tutor_enrolment(course=nil)
    act_course = active_course ? active_course : course
    self.active_course = act_course
    if current_enrolment
      product_version_feature_logs.includes(:master_feature, :course).where("acquired IS NOT NULL AND master_features.name ILIKE '%PrivateTutoringFeature%' AND courses.id = ?", act_course.try(:id)).references(:master_features).first
    end
  end

  def validate_order_presence
    return true if self.orders.present? && !self.orders.where(status: Order.statuses["ongoing"]).includes(:purchase_items).where('purchase_items.id IS NULL OR purchase_items.purchase_description NOT LIKE ?', '%Custom course for Free trail%' || '%Custom course for Expired course%').order(:created_at).references(:purchase_items).empty?

    false
  end

  def validate_order
    if self.orders.present? && !self.orders.where(status: Order.statuses["ongoing"]).includes(:purchase_items).where('purchase_items.id IS NULL OR purchase_items.purchase_description NOT LIKE ?', '%Custom course for Free trail%' || '%Custom course for Expired course%').order(:created_at).references(:purchase_items).empty?
      return self.orders.where(status: Order.statuses["ongoing"]).includes(:purchase_items).where('purchase_items.id IS NULL OR purchase_items.purchase_description NOT LIKE ?', '%Custom course for Free trail%').order(:created_at).references(:purchase_items).first
    else
      return Order.create(user_id: id, status: :ongoing, creator_id: id)
    end
  end

  def validate_order_last
    if self.orders.present? && !self.orders.where(status: Order.statuses["ongoing"]).includes(:purchase_items).where('purchase_items.id IS NULL OR purchase_items.purchase_description NOT LIKE ?', '%Custom course for Free trail%' || '%Custom course for Expired course%').order(:created_at).references(:purchase_items).empty?
      return self.orders.where(status: Order.statuses["ongoing"]).includes(:purchase_items).where('purchase_items.id IS NULL OR purchase_items.purchase_description NOT LIKE ?', '%Custom course for Free trail%').order(:created_at).references(:purchase_items).last
    else
      return Order.create(user_id: id, status: :ongoing, creator_id: id)
    end
  end

  def course_enroled?(course_id)
    paid_enrolments.where.not(state: 'Unenrolled').find_by(course_id: course_id).present?
  end

  def has_only_free_trial?
    paid_enrolments.find_by(trial: true).present? && enrolments.find_by(trial: false).blank?
  end

  def has_free_trial_only?
    paid_enrolments.find_by(trial: true).present? && paid_enrolments.find_by(trial: false).blank?
  end

  def trial_enrolment
    paid_enrolments.find_by(trial: true)
  end

  def trial_course
    trial_enrolment.try(:course)
  end

  def self.events_dates(current_user, current_course)
    events_dates = []
    if current_course.present?
      if current_course.product_version.type == 'GamsatReady'
        events_dates = ["2017-03-25", "2017-09-13"]
      elsif current_course.product_version.type == 'UmatReady'
        events_dates = ["2017-07-26"]
      end
      current_course.lessons.each do |lesson|
        if lesson.date.present?
          events_dates << lesson.date.strftime("%Y-%m-%d")
        end
      end


      EventDate.where(product_line:"All").each do |e|
        if e.event_start_date.present?
          events_dates << e.event_start_date.strftime("%Y-%m-%d")
        end
      end


      EventDate.where(product_line: current_course.product_version.type, product_version_id: current_course.product_version.id).each do |e|
        if e.event_start_date.present?
          events_dates << e.event_start_date.strftime("%Y-%m-%d")
        end
      end

      EventDate.where(product_line: current_course.product_version.type, product_version_id: nil).each do |e|
        if e.event_start_date.present?
          events_dates << e.event_start_date.strftime("%Y-%m-%d")
        end
      end

    else
      EventDate.all.each do |e|
        if e.event_start_date.present?
          events_dates << e.event_start_date.strftime("%Y-%m-%d")
        end
      end

    end

    current_user.courses.each do |e|
      if e.expiry_date.present?
        events_dates << e.expiry_date.strftime("%Y-%m-%d")
      end
    end

    current_user.appointments.active.each do |e|
      if e.start_time.present?
        events_dates << e.start_time.to_date.strftime("%Y-%m-%d")
      end
    end

    EssayResponse.where.not(essay_id: nil).where(user_id: current_user.id).includes(:essay, essay_tutor_response: [staff_profile: [:staff]]).order(:id).each do|e|
      if e.expiry_date.present?
        events_dates << e.expiry_date.strftime("%Y-%m-%d")
      end
    end
    return events_dates
  end

  def self.important_calender_dates(event_date, current_user, current_course)
    if current_course
      gamsat_exam_date =[{"Exam Name" => "GAMSAT" , "Date" => "2017-03-25"},{"Exam Name" => "GAMSAT", "Date" => "2017-09-13"} ]
      umat_exam_date = [{"Exam Name" => "UMAT", "Date" => "2017-07-26"}]
      events = {}

      events["course_enrol_data"] = {}
      events["essay_response_due_data"] = {}
      events["online_material_expiry_data"] = {}
      events["GAMSAT_exams_date"] = {}
      events["UMAT_exams_date"] = {}

      events["course_enrol_data"] = []
      current_course.lessons.where(date: event_date).each do |lesson|
        events["course_enrol_data"] << {"Date" => lesson.date, "Venue" => lesson.location, "Time" => lesson.start_time.strftime("%I:%M%p")+" - "+lesson.end_time.strftime("%I:%M%p"), "Items covered" => lesson.item_covered}
      end

      events["GAMSAT_exams_date"] = []
      gamsat_exam_date.each do |key|
        if key["Date"] == event_date
          events["GAMSAT_exams_date"] << key
        end
      end

      events["UMAT_exams_date"] = []
      umat_exam_date.each do |key|
        if key["Date"] == event_date
          events["UMAT_exams_date"] << key
        end
      end

      events["online_material_expiry_data"] = []
      current_user.courses.where(expiry_date: event_date).each do |e|
        events["online_material_expiry_data"] << {"Course Name" => e.name, "City" => e.city, "Expiry Date" => e.expiry_date}
      end

      events["admin_events_due_data"] = []
      if event_date.present?
        EventDate.where(event_start_date: event_date.to_date.beginning_of_day..event_date.to_date.end_of_day).each do |e|
          events["admin_events_due_data"] << {"Event Title" => e.title, "Event Date"=> e.event_start_date, "Event Time"=>e.event_start_time.strftime("%I:%M%p"), "Description"=>e.description.html_safe}
        end
      end


      events["booked_appointments_due_data"] = []
      if event_date.present?
        current_user.appointments.active.where(start_time: event_date.to_date.beginning_of_day..event_date.to_date.end_of_day).each do |e|
          events["booked_appointments_due_data"] << {
            "Date" => e.start_time.to_date,
            "Time" => e.start_time.strftime("%H:%M %p")+"\-"+e.end_time.strftime("%H:%M %p"),
            "Tutor"=> e.tutor, "Location"=> e.try(:location), "Subjects"=> e.tags.pluck(:name).join(', ')}

        end
      end
      events["essay_response_due_data"] = []
      if event_date.present?
        EssayResponse.where.not(essay_id: nil).where(user_id: current_user.id).includes(:essay, essay_tutor_response: [staff_profile: [:staff]]).order(:id).where(expiry_date: event_date.to_date.beginning_of_day..event_date.to_date.end_of_day).each do |e|
          expiry_time = e.expiry_date.in_time_zone("Australia/Melbourne") + 23.hours + 59.minutes
          events["essay_response_due_data"] << {"Title" => e.essay.title+" to Expire", "Date" => e.expiry_date, "Time" => expiry_time.strftime("%I:%M%p %Z")}
        end
      end

      return events
    else
      []
    end
  end

  def active_for_authentication?
    super && ['activated'].include?(status)
  end

  def inactive_message
    self.status == 'deactivated' ? :account_disabled : super
  end

  def has_clarity_feature
    accessible_features.select { |feature| feature.get_clarity? }
  end

  def has_video_feature
    features = accessible_features.select { |feature| feature.video? }
    features.present? ? true : false
  end

  def has_online_mock_feature
    features = accessible_features.select { |feature| feature.online_mock_exam? }
    features.present? ? true : false
  end

  def has_textbook_feature
    features = accessible_features.select { |feature| feature.textbook? }
    features.present? ? true : false
  end

  def active_essay_feature
    active_enrolment_features.select { |feature| feature.master_feature.essay? }
  end

  def hash_mock_feature
    features = accessible_features.select { |feature| feature.live_exam? }
    features.present? ? true : false
  end

  def exercise_tags
    #TODO Will need to do an abstract method in 1267
    if active_course.present?
      product_version_feature_logs.includes(:enrolment, product_version_feature_price: :master_feature).
          where("enrolments.course_id = ? AND master_features.url = ?", active_course.id, "new_exercise_path")
          .references(:enrolments, :master_features).first.product_version_feature_price.tags.map(&:self_and_descendants).flatten.uniq.sort_by{|tag| tag.name.upcase}
    else
      children_course_tags.sort_by{|tag| tag.name.upcase}
    end
  end

  def active_courses
    active_courses = paid_courses.where('(enrolments.trial = ? OR (enrolments.trial = ? AND enrolments.trial_expiry > ?))', false, true, Time.zone.now).references(:enrolments)
    if active_courses.present?
      active_courses
    else
      paid_courses.where('(enrolments.trial = ? AND enrolments.trial_expiry < ?)', true, Time.zone.now).references(:enrolments)
    end
  end

  def active_enrolled_courses
    active_courses.where("enrolments.state NOT IN (?)", [3])
  end


  def fetch_user_performance_stat(tag , course_id, vods , textbooks)
    tag.self_and_descendants.each do |tg|
      vdo_stats = user_stats.viewable_type("Vod").find_by(tag_id: tg.id)
      textbook_stats = user_stats.viewable_type("Textbook").find_by(tag_id: tg.id)
      unless vdo_stats.present?
        # stuent_stat =  student_subject_performance(tg, vods, self.id)
        average_stat = vods.present? ? avg_subject_performance(tg, vods) : 0
        self.user_stats.create(tag_id: tg.id, viewable_type: "Vod", stuent_stat: 0, average_stat: average_stat)
      end
      unless textbook_stats.present?
        # stuent_stat =  student_subject_performance(tg, textbooks, self.id)
        average_stat = textbooks.present? ? avg_subject_performance(tg, textbooks) : 0
        self.user_stats.create(tag_id: tg.id, viewable_type: "Textbook", stuent_stat: 0, average_stat: average_stat)
      end
    end
    user_stats
  end

  def avg_mcq_stats(tag_id)
    #correct_per_sql =  "SELECT SUM(score) FROM mcq_statistics WHERE mcq_statistics.tag_id = #{tag_id}"
    correct_per_sql = "SELECT score FROM mcq_statistics WHERE mcq_statistics.tag_id = #{tag_id}"

    sql = "SELECT COUNT(*) FROM mcq_statistics WHERE mcq_statistics.tag_id = #{tag_id}"

    #correct_percentage = ActiveRecord::Base.connection.execute(correct_per_sql)
    all_scrores = ActiveRecord::Base.connection.exec_query(correct_per_sql)

    tot_stat = ActiveRecord::Base.connection.execute(sql)

    #correct = correct_percentage.first["sum"].to_i
    scores_arr = all_scrores.rows.flatten
    scores_sum = scores_arr.map(&:to_f).sum.round(2)
    stat_count = tot_stat.first["count"].to_f.round(2)
    avg_stats = scores_sum / stat_count
    avg_stats.round(2)
  end

  def user_exam_stat(tag, exam_attempts)
    correct= []
    attempted = []
    sec_attempts = exam_attempts.map{|a| a.section_attempts}
    sec_attempts.flatten.each do |sa|
      sa_stat = fetch_user_exam_stats(tag , sa.id)
      correct << sa_stat.correct
      # attempted << sa_stat.correct + sa_stat.incorrect
      attempted << sa_stat.total
    end
    correct = correct.inject(0){|sum,x| sum + x }
    attempted = attempted.inject(0){|sum,x| sum + x }
    correct_per = attempted > 0 ? (correct.to_f / attempted) * 100 : 0
    correct_per.round(2)
  end

  def exam_avg_stat(tag)
    # attempts = AssessmentAttempt.where(assessable_type: 'OnlineExam').where.not(completed_at: nil)
    # s_attem = SectionAttempt.where(assessment_attempt_id: attempts.pluck(:id))

    # s_attem_ids = s_attem.pluck(:id).join(',')
    s_attem_ids = (SectionAttempt.joins(:assessment_attempt).where("assessable_type = 'OnlineExam' AND assessment_attempts.completed_at IS NOT NULL").pluck(:id)).join(',')

    correct_sql =  "SELECT SUM(correct) FROM exam_statistics WHERE exam_statistics.tag_id = #{tag.id} AND exam_statistics.section_attempt_id IN (#{s_attem_ids})"
    correct_one = ActiveRecord::Base.connection.execute(correct_sql)

    # incorrect_sql =  "SELECT SUM(incorrect) FROM exam_statistics WHERE exam_statistics.tag_id = #{tag.id} AND exam_statistics.section_attempt_id IN (#{s_attem_ids})"
    # incorrect_one = ActiveRecord::Base.connection.execute(incorrect_sql)
    total_sql =  "SELECT SUM(total) FROM exam_statistics WHERE exam_statistics.tag_id = #{tag.id} AND exam_statistics.section_attempt_id IN (#{s_attem_ids})"
    total_one = ActiveRecord::Base.connection.execute(total_sql)

    correct = correct_one.first["sum"].to_i
    # incorrect = incorrect_one.first["sum"].to_i
    # attempted = correct + incorrect
    attempted = total_one.first["sum"].to_i
    correct_percen = (correct.to_f / attempted) * 100
    correct_percen.round(2)

    # sql = "SELECT COUNT(*) FROM exam_statistics WHERE exam_statistics.tag_id = #{tag.id} AND exam_statistics.section_attempt_id IN (#{s_attem_ids})"

    # tot_stat = ActiveRecord::Base.connection.execute(sql)

    # stat_count = tot_stat.first["count"].to_i
    # avg_stats = correct_percen / stat_count

    # avg_stats.round(2)
  end

  def fetch_user_mcq_stats(tag_id)
    mcq_statistic = mcq_statistics.find_by(tag_id: tag_id, course_id: active_course.try(:id))
    if mcq_statistic.present? && mcq_statistic.score.to_s=="Infinity"
      mcq_statistic.update(score:0.0)
    end
    unless mcq_statistic.present?
      used = 0.0
      score = 0.0
      correct_per = 0.0

      tag = Tag.find(tag_id)
      tag_ids = tag.self_and_descendants_ids
      mcq_stems_params = { mcq_stems: { published: true, examinable: false } }
      total = Mcq.includes(:mcq_stem, :tagging).where(**mcq_stems_params, taggings: { tag_id: tag_ids }).size
      mcq_attempts1 = mcq_attempts.joins(:exercise, :mcq_stem, [mcq: :tagging]).left_joins(:mcq_answer).where.not(exercises: { completed_at: nil }).where(exercises: {course_id: active_course.try(:id)},**mcq_stems_params, taggings: { tag_id: tag_ids }).select("CASE WHEN (mcq_answers.correct = true) THEN COUNT(mcq_attempts.*) END AS correct, CASE WHEN (mcq_answers.correct = false) THEN COUNT(mcq_attempts.*) END AS incorrect ,count(mcq_attempts.*) AS viewed").group('mcq_answers.correct').as_json
      viewed = correct = mcq_attempts1.map{|x| x["viewed"]}.compact.sum
      correct = mcq_attempts1.map{|x| x["correct"]}.compact.sum
      incorrect =  mcq_attempts1.map{|x| x["incorrect"]}.compact.sum
      attempted = correct + incorrect
      used = (viewed.to_f / total * 100).round(1) if total > 0
      score = (correct.to_f / viewed * 100).round(1) if viewed > 0
      correct_per = attempted > 0 ? (correct.to_f / attempted * 100).round(2) : 0
      mcq_statistic = self.mcq_statistics.create(tag_id: tag_id, course_id: active_course.try(:id), total: total, viewed: viewed, correct: correct, used: used, score: score, incorrect: incorrect, correct_per: correct_per)
    end
    mcq_statistic
  end

  def create_tag_mcq_statistic
    tags = current_feature_tags('McqFeature')
    tags.each do |tag|
      tag_ids = tag.self_and_descendants_ids
      total = Mcq.includes(mcq_stem: :taggings).where(mcq_stems: { published: true, examinable: false }, taggings: { tag_id: tag_ids }).count
      self.mcq_statistics.create(tag_id: tag.id, course_id: active_course.try(:id), total: total)
    end
  end

  def essay_performance(essays_responses)
    # marked_essays_ids = essays_responses.pluck(:id) if essays_responses.present?

    marked_essays_ids = essays_responses.pluck(:id).join(',') if essays_responses.present?
    if marked_essays_ids.present?
      # tutor_responses = EssayTutorResponse.where(essay_response_id: marked_essays_ids)
      # rating = tutor_responses.map{|a| [(a.rating.to_f * 100 ) / 75 ]}.flatten
      # total = rating.inject(0){|sum,x| sum + x }
      # result = total / tutor_responses.count
      # result.round(2)

      responses_rating = "SELECT SUM(rating) FROM essay_tutor_responses WHERE essay_tutor_responses.essay_response_id IN (#{marked_essays_ids})"

      rating_percentage = ActiveRecord::Base.connection.execute(responses_rating)

      rating_count = rating_percentage.first["sum"].to_i

      responses_total = "SELECT COUNT(*) FROM essay_tutor_responses WHERE essay_tutor_responses.essay_response_id IN (#{marked_essays_ids})"

      responses_total_number = ActiveRecord::Base.connection.execute(responses_total)

      responses_count = responses_total_number.first["count"].to_i

      result = (rating_count.to_f / (responses_count * 75) ) * 100
      result.round(2)
    else
      0
    end
  end

  def recommended_topics_count(user , tag, ol_exams)
    viewed_attempts = user.mcq_attempts.includes(:exercise).where.not(exercises: { completed_at: nil })
    # attempts = viewed_attempts.includes(:mcq_stem).where.not(mcq_answer_id: nil).where(mcq_stems: { published: true })

    attempts = viewed_attempts.includes(:mcq_stem).where("mcq_answer_id IS NOT NULL AND mcq_stems.published IS true")

    # exam_attempts = user.section_item_attempts.includes(:mcq_stem).where(mcq_stems: { published: true }).where.not(mcq_answer_id: nil)

    exam_attempts = user.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where.not(mcq_answer_id: nil)

    red_tags = []
    orange_tags = []
    yellow_tags = []
    unassessed_topics_tags = []
    tag.self_and_descendants.each do |t|
      tag_ids = t.self_and_descendants_ids
      mcq_count = attempts.with_tag(tag_ids).count
      exam_count = exam_attempts.with_tag(tag_ids).count
      tot_attempt = mcq_count + exam_count
      if tot_attempt > 10
        mcq_avgg = avg_mcq_stats(t.id)
        mcq_stu_per = user.fetch_user_mcq_stats(t.id).score
        exam_avgg = exam_avg_stat(t)
        exam_stu_per = ol_exams.present? ? user.user_exam_stat(t, ol_exams) : 0
        stu_per = ((mcq_stu_per + exam_stu_per) / 2).round(2)
        avgg = ((mcq_avgg + exam_avgg) / 2).round(2)
        if stu_per < avgg
          if  stu_per > 20
            red_tags << [t.name ,  stu_per]
          elsif stu_per > 10 && stu_per < 20
            orange_tags << [t.name ,  stu_per]
          elsif stu_per <= 10
            yellow_tags << [t.name ,  stu_per]
          end

        end
      else
        unassessed_topics_tags << [t.name ,  0.0]
      end
    end

    tot_topics = {}
    tot_topics["red_tags"] = red_tags
    tot_topics["orange_tags"] = orange_tags
    tot_topics["yellow_tags"] = yellow_tags
    tot_topics["unassessed_topics_tags"] = unassessed_topics_tags
    tot_topics
  end

  def fetch_user_exam_stats(sec_tag = nil, sec_id)
    sec_attempt = section_attempts.find(sec_id.id)
    sec_tag ||= sec_attempt.section.sectionable.tags.first
    exam_statistic = exam_statistics.find_by(tag_id: sec_tag.id, course_id: active_course.try(:id), section_attempt_id: sec_attempt.id )
    unless exam_statistic.present?

      tag_ids = sec_tag.self_and_descendants_ids

      correct_ans = sec_attempt.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where(mcq_answers: { correct: true })
      correct_ans = correct_ans.where(taggings: { tag_id: tag_ids }) if sec_tag.present?
      correct = correct_ans.size

      incorrect_ans = sec_attempt.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where(mcq_answers: { correct: false })
      incorrect_ans = incorrect_ans.where(taggings: { tag_id: tag_ids }) if sec_tag.present?
      incorrect = incorrect_ans.size

      # total_ques = sec_attempt.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {})
      # total_ques = total_ques.where(taggings: { tag_id: tag_ids })  if sec_tag.present?


      total_ques= sec_attempt.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).where(taggings: { tag_id: tag_ids })
      total = total_ques.size
      #total = sec_attempt.section.mcq_stems.joins(:tags).where('tags.id IN (?)', tag_ids).count

      section_item_attempts = sec_attempt.section_item_attempts.includes(mcq: { tagging: {} }, mcq_answer: {}).select{|att| att.mcq.try(:tags).try(:any?){|t| t.self_and_ancestors.include?(sec_tag) if t }}
      mcq_ids = section_item_attempts.collect{|m| m.mcq_stem_id}
      time_taken = sec_attempt.mcq_attempt_times.where(mcq_stem_id: mcq_ids).sum(:total_time)

      exam_statistic = self.exam_statistics.create(tag_id: sec_tag.id, course_id: active_course.try(:id), section_attempt_id: sec_attempt.id, total: total, incorrect: incorrect, correct: correct, time_taken: time_taken)
    end
    exam_statistic
  end

  def fetch_user_exam_stats_result(sec_tag=nil, sec_id)
    exam_statistic = fetch_user_exam_stats(sec_tag, sec_id)
    result = {}
    result['score'] = exam_statistic.score
    result['total'] = exam_statistic.total
    result['correct'] = exam_statistic.correct
    result['incorrect'] = exam_statistic.incorrect
    result['total_time'] = exam_statistic.taken_time
    result['not_attempted'] = exam_statistic.total - exam_statistic.correct - exam_statistic.incorrect
    total_time = exam_statistic.total_time_section
    tol_ques = exam_statistic.correct + exam_statistic.incorrect
    time_per_question = Time.at(total_time / tol_ques).utc.strftime("%M min %S sec") if tol_ques != 0
    result['time_per_question'] = time_per_question if tol_ques != 0
    result
  end

  def trial_enrolments
    paid_enrolments.where(trial: true)
  end

  def trial_course_name
    trial_enrolments.present? ? trial_enrolments.first.course.name : ""
  end

  def trial_course_name_free enrol
    enrolment = enrol
    if enrolment.present?
      enrolment.course.name
    end
  end

  def enrolled_in_trial
    trial_enrolments.present? ? "Yes" : "No"
  end

  def purchased_courses
    order_ids = orders.select{|o| o.paid? || o.free? }.map(&:id)
    p_courses = courses.where("orders.user_id = ? AND orders.id IN (?)", id, order_ids).order('orders.paid_at').references(:orders)
    fl_ids = purchase_items.where(purchasable_type: "FeatureLog").select{ |p|  p.order.paid? || p.order.free? }.map(&:purchasable_id)
    f_courses = courses.includes(enrolments: :feature_logs).where(feature_logs: {id: fl_ids})
    (p_courses + f_courses).uniq
  end

  def total_commulative_spend
    to_cost = 0
    if self.purchase_items.present?
      pur_items = self.purchase_items.select{ |p|  p.order.paid? }
      pur_items.each do |purchase_it|
        to_cost += purchase_it.order.total_cost
      end
    end
    to_cost
  end

  def course_purchase_date(course_id)
    enrolment = enrolments.find_by(course_id: course_id)
    if enrolment.present?
      if enrolment.order.paid_at.present?
        enrolment.order.paid_at.to_date.strftime('%d/%m/%Y')
      else
        enrolment.order.created_at.to_date.strftime('%d/%m/%Y')
      end
    end
  end

  def textbook_shipping_cost
    shipping_cost = 0
    location = self.country
    shipping = Shipping.find_by(country: location)
    shipping_cost = shipping.shipping_amount if shipping
    shipping_cost
  end

  def referals_count
    user_id = []
    promos.each do |promo|
      user_id << promo.orders.select{|p| p.paid? }.map(&:user_id)
    end
    User.where(id: user_id).where.not(id: self.id).count
  end

  def update_feature_access_count
    self.update_attribute(:feature_access_count, feature_access_count + 1)
  end

  def current_course_mcq_count course_id
    mcq_attempt_mcqs.includes(mcq_attempts: :exercise).where.not(exercises: { completed_at: nil }).where(exercises: {course_id: course_id}).count
  end

  def enrol_current_course_mcq_count
    course_ids = enrolments.where(trial: false).pluck(:course_id)
    mcq_attempt_mcqs.includes(mcq_attempts: :exercise).where.not(exercises: { completed_at: nil }).where(exercises: {course_id: course_ids}).count
  end

  def send_emails_after_confirmation
    enrolments.each do |en|
      en.order.send_essay_mail
    end
    mail_pendings.pending.each do |pending_mail|
      pending_mail.send_emails_after_confirmation
    end
  end

  def essay_data_transfer staff_id
    @staff = User.find(staff_id)
    new_staff_profile = @staff.staff_profile
    tutor_essays = Essay.where(tutor_id: self.id)
    tutor_essays.update_all(tutor_id: staff_id)
    tutor_responses = EssayResponse.where(tutor_id: self.id)
    tutor_responses.update_all(tutor_id: staff_id)
    tutor_essay_responses = staff_profile.essay_tutor_responses
    tutor_essay_responses.update_all(staff_profile_id: new_staff_profile.id)
    course_ids = staff_profile.course_staffs.pluck(:course_id)

    course_ids.each do |course_id|
      profile = staff_profile.course_staffs.find_by(course_id: course_id)
      new_profile = new_staff_profile.course_staffs.find_by(course_id: course_id)
      if new_profile
        profile.destroy
      else
        profile.update(staff_profile_id: new_staff_profile.id) if profile
      end
   end
  end

  def all_data_transfer_except_essay staff_id
    # Transfer create mcq stem data
    mcq_stems_authored.update_all(author_id: staff_id)
    # Transfer revi mcq data
    mcq_stems_reviewed.update_all(reviewer_id: staff_id)
    #Transfer documents data
    documents.update_all(user_id: staff_id)
    #Transfer textbooks data
    textbooks.update_all(user_id: staff_id)
    #Transfer access_documents data
    access_documents.update_all(user_id: staff_id)
    #Transfer votes data
    votes.update_all(user_id: staff_id)
    #transfer ticket answers data
    ticket_answers.update_all(user_id: staff_id)
    #transfer ticket answers data
    clarifications.update_all(user_id: staff_id)
    #transfer_transactions
    transfer_transactions.update_all(user_id: staff_id)

    #transfer appoinments
    staff = User.find staff_id
    staff_tutor_profile = staff.tutor_profile
    tutor_profile.tutor_availabilities.update_all(tutor_profile_id: staff_tutor_profile.id)
    tutor_profile.tutor_schedules.update_all(tutor_profile_id: staff_tutor_profile.id)

    #transfer tickets
    tickets = Ticket.where(answerer_id: self.id)
    tickets.update_all(answerer_id: staff_id)
  end

  def fetch_thankyou_path
    if enrolments.present?
      enrolment = enrolments.first
      type = enrolment.course.product_version.type
      course_type = ProductVersion.course_types[enrolment.course.product_version.course_type]

      if [2,3,9].include?(course_type)
        path = Rails.application.routes.url_helpers.thankyou_ir_path
      elsif enrolment.trial
        path = type == 'UmatReady' ? Rails.application.routes.url_helpers.thankyou_umattrial_path : Rails.application.routes.url_helpers.thankyou_gamsattrial_path
      else
        path = type == 'UmatReady' ? Rails.application.routes.url_helpers.thankyou_umat_path : Rails.application.routes.url_helpers.thankyou_gamsat_path
      end
    else
      path = Rails.application.routes.url_helpers.thankyou_gamsat_path
    end
  end

  def update_active_course course_id
    self.update_attribute(:active_course_id, course_id) if course_id.present?
  end

  def online_exam_feature
    active_enrolment_features.includes(:master_feature).where('master_features.name LIKE ? AND master_features.name NOT LIKE ?', '%ExamFeature%', '%Live%')
  end

  def self.is_valid_date?(input_date)
    check = false
    begin
      y, m, d = input_date.split '-'
      check = Date.valid_date?(y.to_i, d.to_i, m.to_i)
    rescue
    end
    return check
  end

  def can_manage_admin
    self.superadmin? || self.admin? || self.manager?
  end

  private

  def delete_photo
    self.photo = nil
  end

  def send_first_welcome_email
    return if self.confirmed_at.nil?
    UserMailer.send_first_welcome_email(self).deliver_later if ENV['EMAIL_CONFIRMABLE'] != "false"
  end

  def create_user_announcements
    Announcement.all.each do |announcement|
      announcement.user_announcements.create(user_id: self.id, viewed: false)
    end
  end

end
