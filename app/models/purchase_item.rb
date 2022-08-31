class PurchaseItem < ApplicationRecord
  # t.decimal  "initial_cost",         precision: 8, scale: 2
  # t.decimal  "added_gst",            precision: 8, scale: 2
  # t.decimal  "method_fee",           precision: 8, scale: 2
  # t.string   "purchase_description"
  # t.string   "purchase_method"
  # t.integer  "order_id"
  # t.integer  "user_id"
  # t.integer  "purchasable_id"
  # t.string   "purchasable_type"
  # t.datetime "created_at",                                                 null: false
  # t.datetime "updated_at",                                                 null: false
  # t.decimal  "discount_applied",
  belongs_to :order
  belongs_to :user
  belongs_to :purchasable, polymorphic: true
  belongs_to :enrolment, -> { joins(:purchase_item).where(purchase_items: { purchasable_type: 'Enrolment'}) }, foreign_key: 'purchasable_id', optional: true

  # validates :user, presence: true
  validates :order, presence: true
  validates :purchasable_id, presence: true
  #validates :initial_cost

  before_create :set_initial_variables


  def set_initial_variables
    self.added_gst=BigDecimal.new("0.1")*self.initial_cost if (self.initial_cost.present? && !self.added_gst.present?)
    self.method_fee = 0
  end

  def total_item_cost
    if self.method_fee.nil?
      self.method_fee = BigDecimal.new("0")
    end
    return self.initial_cost + self.method_fee + self.added_gst - self.discount_applied
  end

  def self.clear_cart
    # Destroys all purchase items assoiciated with an ongoing purchase order
    PurchaseItem.includes(:order).where("orders.status = ?", Order.statuses["ongoing"]).references(:orders).each do |pi|
      pi.destroy
    end

  end

  def custom_course_description
    description = purchase_description
    purchasable.feature_logs.where(description: 'custom purchase').each do |fl|
      description += ','
      description += fl.master_feature.custom_feature_name(fl.product_version_feature_price.qty, purchasable.course.product_version.try(:type))
    end
    description
  end
end
