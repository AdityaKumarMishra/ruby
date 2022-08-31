class ProductVersionFeaturePrice < ApplicationRecord
  belongs_to :master_feature
  belongs_to :product_version
  has_many :feature_logs, dependent: :destroy
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings
  validates :master_feature_id, presence: true
  before_save :update_subtype_change_date, if: ->{ subtype_changed? }
  before_save :update_qty_if_zero, if: ->{ qty_changed? }

  enum subtype: [:subtype_1, :subtype_2]

  attr_accessor :unlimited

  def update_subtype_change_date
    self.subtype_change_date = Time.zone.now.to_s
  end

  def update_qty_if_zero
    self.qty = nil if self.qty.zero?
  end

  def enrolment_feature_log(user_id, enrolment_id=nil, qty=nil)
    enrolment_ids = User.find(user_id).enrolments.pluck(:id)
    if qty.present?
      feature_log = feature_logs.find_by(acquired: nil, enrolment_id: enrolment_ids, qty: qty)
    else
      feature_log = feature_logs.find_by(acquired: nil, enrolment_id: enrolment_ids)
    end
    if (feature_log.nil? || feature_log.enrolment_id != enrolment_id) && enrolment_id.present?
      feature_log = feature_logs.create(acquired: nil, enrolment_id: enrolment_id, qty: qty || self.qty)
    end
    feature_log
  end

  def price_with_gst
    self.price * 1.1
  end

  def enrol_feature_log(user_id, enrolment_id=nil, master_feature_id=nil)
    if enrolment_id.present?
      enrolment_ids = enrolment_id
    else
      enrolment_ids = User.find(user_id).enrolments.pluck(:id)
    end

    if master_feature_id.present?
      f_log = feature_logs.includes(:master_feature).where("acquired IS NOT NULL AND enrolment_id IN (?) AND master_features.id = ?",  enrolment_ids, master_feature_id).references(:master_feature)
    else
      f_log = feature_logs.where("acquired IS NOT NULL AND enrolment_id IN (?)",  enrolment_ids)
    end

    unless f_log.present?
      f_log = feature_logs.where(enrolment_id: enrolment_ids)
    end
    unless f_log.present?
      description = master_feature.essay? ? "#{qty} numbers of essays" : "#{qty} hours of tutoring"
      f_log = feature_logs.find_or_create_by(acquired: nil, enrolment_id: enrolment_id, qty: self.qty, description: description)
      f_log = feature_logs.where(id: f_log.id)
    end
    f_log
  end

  def enrolment_feature_activated(user_id, enrolment_id=nil, master_feature_id)
    mf = MasterFeature.find(master_feature_id)
    feature_log = enrol_feature_log(user_id, enrolment_id, master_feature_id)
    if mf.essay? || mf.private_tutoring? || mf.exam_feature?
      false
    else
      feature_log.where.not(acquired: nil).present? ? true : false
    end
  end

  def self.get_price(product_line, master_feature_id)
    if product_line.name=="gamsat"
      product_version_id="10"
    elsif product_line.name=="umat"
      product_version_id="18"
    elsif product_line.name=="hsc"
      product_version_id="80"
    elsif product_line.name=="vce"
      product_version_id="44"
    end

    if self.find_by(product_version_id: product_version_id, master_feature_id: master_feature_id).try(:price).nil?
      return 0.0
    else
      return self.find_by(product_version_id: product_version_id, master_feature_id: master_feature_id).try(:price)
    end
  end

  def selected_feature_tag(product_line, course_type=nil)
    selected = if product_line.name=="gamsat"
                if [2, 3, 9].include?(course_type.to_i)
                  324
                else
                  246
                end
              elsif product_line.name=="umat"
                30
              elsif product_line.name=="hsc"
                38
              elsif product_line.name=="vce"
                37
              else
                246
              end
    return selected
  end

  def ten_percent_gst
    gst = ((10 * price) / 100).ceil
    result = "$#{price} + 10% GST = $#{(price+gst)}"
  end

  def ten_percent_gst_amount
    gst = ((10 * price) / 100)
    price + gst
  end

  def price_after_discount
    discount = ((25 * ten_percent_gst_amount) / 100).ceil
    ten_percent_gst_amount - discount
  end

  def calucate_purchase_unit(enrolment_id)
    logs = feature_logs.where(enrolment_id: enrolment_id)
    purchase_logs = logs.where.not(acquired: nil)
    if purchase_logs.present?
      purchase_logs.where.not(qty: nil).present? ? purchase_logs.where.not(qty: nil).sum(:qty) : '∞'
    else
      '0'
    end
  end

  def find_exam_feature_logs(enrolment_id)
    feature_logs.where(enrolment_id: enrolment_id)
  end

  def find_essay_feature_logs(enrolment_id)
    feature_logs.where(enrolment_id: enrolment_id)
  end


  def find_purchase_feature_log(enrolment_id)
    logs = feature_logs.where(enrolment_id: enrolment_id)
    purchase_logs = logs.where.not(acquired: nil)
    purchase_logs.first
  end

  def one_mcq_price
    return nil if qty.nil?
    price/qty
  end
end
