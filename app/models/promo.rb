class Promo < ApplicationRecord
  belongs_to :user
  belongs_to :purchaseable, polymorphic: true, optional: true
  belongs_to :generated_from, class_name: "Order", optional: true
  has_many :orders_promos
  has_many :orders, through: :orders_promos
  has_many :promo_visits, dependent: :destroy
  validate :used_times_validation, on: [:create, :update]

  validate :expiration_date_cannot_be_in_the_past, on: [:create, :update]
  validates :name, presence: true

  enum strategy: [ :percentage ]

  # code for the promo applicable for the course purchased if user's existing course (not custom, starting or Interview ready) is expired
  B_PROMOCODE  = "GREXPD25"
  #code for the promo applicable for the IR course purchased if user's existing course (not custom, starting or Interview ready) is expired
  B_IR_PROMOCODE  = "GREXPD10"
  #social media crawlers
  SOCIAL_MEDIA_CRAWLERS = [
    'facebookexternalhit/1.1 (+http://www.facebook.com/externalhit_uatext.php)',
    'facebookexternalhit/1.1',
    'Facebot'
  ]

  filterrific(
    available_filters: [
      :with_start,
      :with_end
    ]
  )

  scope :with_start, -> (with_start) do
    where('date(promos.created_at) >= ?', with_start)
  end
  scope :with_end, -> (with_end) do
    where('date(promos.created_at) <= ?', with_end)
  end

  # This method tracks clicks but not purchases
  def visit!
    promo_visits.create
  end

  # Number of times the promo link has been clicked
  def visit_count
    promo_visits.count
  end

  # Number of purchases made with this promo code
  def purchase_count
    orders.where.not(status: Order.statuses[:ongoing]).count
  end

  def calculate!(purchase_items)
    strat = self.method("strategy_#{self.strategy}".to_sym)
    purchase_items.each do |item|
      next if ((!self.purchaseable.nil? && self.purchaseable != item.purchasable) || (item.purchasable_type == "FeatureLog" && (self.token == B_PROMOCODE || self.token == B_IR_PROMOCODE))||(item.purchasable_type == "Enrolment" && !is_expired_course_exists?(item.user) && (self.token == B_PROMOCODE || self.token == B_IR_PROMOCODE)))
      strat.call item, self.name
    end
  end

  def strategy_percentage(item, name)
    item.discount_applied += (((item.initial_cost.to_f + item.added_gst.to_f) * self.amount.to_f)/100).to_f.round(0)

    if item.discount_applied > (item.initial_cost + item.added_gst)
      item.discount_applied = (item.initial_cost + item.added_gst)
    end
    item.discount_name = name if item.discount_applied.to_i > 0
    item.save
  end

  def self.find_by_token(token)
    return nil if token.nil?

    find_by(token: token.upcase)
  end

  def token=(token)
    token.upcase! unless token.nil?
    super token
  end

  def generate_token!
    return unless self.token.blank?

    while true
      # Keep generating new tokens until a unique one is found.
      # In practice, we will find a unique one on the first try, 99.9998% of the time
      #
      # With the following algorithm, there are 29^8 = 5.00x10^11 unique combinations
      # Even with 4 billion promos, there are 4.96x10^11 combinations remaining
      # The chances of a collision is ~0.86% with 4 billion existing tokens
      # The chances we don't find a unique token on the next try is negligible
      begin
        # A quick algorithm for generating a human readable token
        allowable_characters = "ABCDEFGHJKLMPQRTUVWXYZ2346789"

        self.token = (0...8).map {
          i = SecureRandom.random_number(allowable_characters.length)
          allowable_characters[i]
        }.join ''

        self.save!

        return self.token
      rescue ActiveRecord::RecordNotUnique
        # Retry
      end
    end
  end

  private
  def used_times_validation
    if used_times < 1
      errors.add(:used_times, 'Must be greater the 0')
    end
  end

  def expiration_date_cannot_be_in_the_past
    if expiry_date.present? && expiry_date < Date.today
      errors.add(:expiry_date, "can't be in the past")
    end
  end

  def is_expired_course_exists? current_user
    current_user.courses.where.not("name like (?) OR name like (?) OR name like (?) OR trial_enabled = ?", "%Custom%", "%Start", "%Interview%", true).map(&:expired?).include?(true)
  end

  def is_interviewready_course? item
    item.purchasable_type == "Enrolment" ? [2, 3, 9].include?(ProductVersion.course_types[item.purchasable.product_version.course_type]) : false
  end
end
