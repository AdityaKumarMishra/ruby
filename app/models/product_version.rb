require "sti_preload"
class ProductVersion < ApplicationRecord
  belongs_to :product_line
  has_many :courses, dependent: :destroy
  has_many :users, through: :courses
  has_one :announcement
  has_many :product_version_feature_prices, dependent: :destroy
  has_many :tags,-> { distinct }, through: :product_version_feature_prices
  has_many :master_features, through: :product_version_feature_prices
  has_many :features
  accepts_nested_attributes_for :product_version_feature_prices, allow_destroy: true
  validates :price, :course_type, presence: true

  enum course_type: [:free_trial, :custom, :interview_attendance_essentials, :interview_attendance_comprehensive, :online_essential, :online_comprehensive, :attendance_essential , :attendance_comprehensive, :attendance_complete, :interview_online_essentials, :free_study_guide, :starter_course, :success_assured]

  after_create :update_couple_name

  DEFAULT_NUM_SUB_QUESTIONS = 3


  filterrific(
      available_filters: [
        :by_product_line,
        :search_by_title,
        :by_type
      ]
  )

  extend FriendlyId
  friendly_id :name, use: :slugged

  # TODO: will be removed when/if ProductLine model will be added
  scope :by_product_line, -> (product_line) { where('type like ?', "#{product_line}%") }
  scope :by_master_feature, -> (mf_id) { mf_id.present? ? joins(:master_features).where(master_features: { id: mf_id }).uniq : all }
  # scope :search_by_title, -> (title){ where "name ILIKE :name OR course_type ILIKE :name OR name ||' '|| course_type ILIKE :name OR course_type ||' '|| name ILIKE :name", name: "%#{title}%" }
  scope :search_by_title, lambda {|query|
    return nil if query.blank?
    term = query.to_s.downcase
    term = ('%' + term.tr('*', '%').tr('\'','\\') + '%').gsub(/%+/, '%')
    self.where("name ILIKE ?", term)
  }
  scope :by_type, -> (type){ where(course_type: type)}

  def self.options_for_course_type
    ProductVersion.course_types.map {|key,value| [key.split('_').join(' ').titleize, value]}.sort_by { |key, value| key }
  end


  def inactive_features
    self.features.where(is_default:false)
  end

  def active_features
    self.features.where(is_default:true)
  end

  def price_with_gst
    (price * 1.1).round(2)
  end

  def self.sort_order
    []
  end

  #Gets all FeatureTypes available for this ProductVersion
  def all_features
    MasterFeature.type(self.type)
  end

  # Ensures that all users of this product version has all the default features.
  # This needs to be done, for example, when the product version is edited and new features
  # are added
  def update_user_features(master_ids=nil)
    if master_ids.present?
      Enrolment.includes(:order, :course)
               .where(order: { user_id: users.ids, status: [2, 3] }, course: { product_version_id: self.id })
               .where.not(state: 'Unenrolled')
               .references(:order, :course)
               .find_each do |enrolment|
        product_version_feature_prices.where.not(is_additional: true).find_each do |feature|
          if master_ids.include?(feature.master_feature_id)
            feature_logs = feature.feature_logs.where(enrolment_id: enrolment.id)
            acquired = feature.is_default ? DateTime.now : nil
            if feature_logs.present?
              feature_logs.update_all(acquired: acquired, qty: feature.qty)
            else
              feature_logs.first_or_create(acquired: acquired, qty: feature.qty)
            end
          end
        end
      end
    end
  end

  def update_features!
    #Add missing features from the product version
    # Is run upon opening edit as often old ProductVersions do not get the new features
    existing_features = master_features.pluck(:name)
    all_features.each do |type|
      unless existing_features.include? type.name
        master_features.build({
                           name: type.name,
                       })
      end
    end
  end

  def build_associations
    DEFAULT_NUM_SUB_QUESTIONS.times { product_version_feature_prices.build } if self.product_version_feature_prices.empty?
  end

  def fetch_show_path(different_course=nil, course_id=nil, pvfps=nil)
    case type
    when 'GamsatReady'
      if slug.present? && slug=="umat-free-trial"
        new_slug= "free-trial"
      else
        new_slug= slug
      end

      if different_course.present?
        Rails.application.routes.url_helpers.gamsat_ready_path(id: new_slug, different_course: true, course_id: course_id, pvfp_ids: pvfps.present? ? pvfps[:pvfp_ids] : nil)
      else
        Rails.application.routes.url_helpers.gamsat_ready_path(id: new_slug)
      end
    when 'UmatReady'
      if slug.present? && slug=="umat-free-trial"
        new_slug= "free-trial"
      else
        new_slug= slug
      end
      if different_course.present?
        Rails.application.routes.url_helpers.umat_ready_path(id: new_slug, different_course: true, course_id: course_id, pvfp_ids: pvfps.present? ? pvfps[:pvfp_ids] : nil)
      else
        Rails.application.routes.url_helpers.umat_ready_path(id: new_slug)
      end
    when 'VceReady'
      if different_course.present?
        Rails.application.routes.url_helpers.vce_ready_path(id: slug, different_course: true, course_id: course_id, pvfp_ids: pvfps.present? ? pvfps[:pvfp_ids] : nil)
      else
        Rails.application.routes.url_helpers.vce_ready_path(id: slug)
      end
    when 'HscReady'
      if different_course.present?
        Rails.application.routes.url_helpers.hsc_ready_path(id: slug, different_course: true, course_id: course_id, pvfp_ids: pvfps.present? ? pvfps[:pvfp_ids] : nil)
      else
        Rails.application.routes.url_helpers.hsc_ready_path(id: slug)
      end
    end
  end

  def textbooks_features_tags
    ids = product_version_feature_prices.pluck(:id)
    master_feature_ids = master_features.collect{|m| m.id if m.textbook?}.compact
    pvfps = ProductVersionFeaturePrice.where(id: ids, master_feature_id: master_feature_ids)
    tags = Tag.includes(:taggings).where("taggings.taggable_type = 'ProductVersionFeaturePrice' AND taggings.taggable_id IN (?)",pvfps.pluck(:id)).references(:taggings)
    tags = tags.collect{|s| s.self_and_descendants}.flatten
    tags.map { |t| [t.name, t.id] }
  end

  def set_product_line
    case type
    when 'GamsatReady'
      product_line = ProductLine.find_or_create_by(name: 'gamsat')
      self.update_attribute(:product_line_id, product_line.id)
    when 'UmatReady'
      product_line = ProductLine.find_or_create_by(name: 'umat')
      self.update_attribute(:product_line_id, product_line.id)
    when 'VceReady'
      product_line = ProductLine.find_or_create_by(name: 'vce')
      self.update_attribute(:product_line_id, product_line.id)
    when 'HscReady'
      product_line = ProductLine.find_or_create_by(name: 'hsc')
      self.update_attribute(:product_line_id, product_line.id)
    end
  end

  def course_type_features
  end

  def pv_detail
    if self.course_type.present?
      self.name + " (#{self.course_type.titleize})" + " (#{self.type})"
    else
      self.name +  " (#{self.type})"
    end
  end

  def pv_active_courses
    if courses.where('enrolment_end_date >= ?', Time.zone.now.beginning_of_day).present?
      true
    else
      false
    end
  end

  def get_master_feature_price(master_feature_id)
    if !product_version_feature_prices.where(master_feature_id: master_feature_id, is_additional: false).present?
      return 0.0
    else
      pv = product_version_feature_prices.where(master_feature_id: master_feature_id, is_additional: false).order("price DESC").first
      pv.price.present? ? pv.price : 0.0
    end
  end

  def get_master_feature_default(master_feature_id)
    product_version_feature_prices.find_by(master_feature_id: master_feature_id, is_additional: false).try(:is_default)
  end

  def online_courses_price type
    case ProductVersion.course_types[course_type]
    when 0
      '0'
    when 4
      type == 'gamsat' ? '979' : '979'
    when 5
      type == 'gamsat' ? '1632' : '1254'
    when 10
      '0'
    when 11
      type == 'gamsat' ? '333' : '265'
    end
  end

  def attendance_courses_price type
    case ProductVersion.course_types[course_type]
    when 2
      ''
    when 3
      ''
    when 6
      type == 'gamsat' ? '3055' : '1556'
    when 7
      type == 'gamsat' ? '3493' : '1831'
    when 8
      type == 'gamsat' ? '4254' : '2376'
    when 9
      ''
    end
  end

  def is_pre_employment?
    name.downcase.include?("pre-employment")
  end
end

private
  def update_couple_name
    self.update(couple_name: self.name)
  end
