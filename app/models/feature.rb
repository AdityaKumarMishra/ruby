class Feature < ApplicationRecord
  belongs_to :product_version
  has_many :taggings, as: :taggable, dependent: :destroy
  has_many :tags, through: :taggings

  def self.enabled_options
    [:default, :purchasable, :disabled]
  end

  # 'enabled' is a fake attribute that is an abstraction of is_default
  def enabled
    is_default ? :default : :purchasable
  end
  def enabled=(val)
    case val.to_sym
      when :default
        self.is_default = true
      when :purchasable
        self.is_default = false
      when :disabled
        destroy
    end
  end

  def feature_type
    self.product_version.all_features.select do |feat|
      feat.name == self.name
    end.first
  end

  def human_readable
    self.name.tr('_', ' ').strip.capitalize
  end

  def sort_index
    self.product_version.class.sort_order.find_index(self.name) || 0
  end

  def price_with_gst
    self.price * 1.1
  end

  def to_partial_path(show_underscore = false)
    feature_type
    # underscore = show_underscore ? '_' : ''
    # "pages/partial/#{self.product_version.class.name.underscore}_features/#{underscore}#{self.name}"
    # # case self.product_version.type
    #   when GamsatReady.name
    #     'pages/partial/gamsat_feature/' + self.name
    #   when UmatReady.name
    #     'pages/partial/umat_ready_features/' + self.name
    # end
  end

  def private_tutoring?
    PrivateTutoringFeature.descendants.map(&:name).include?(self.name)
  end

  def essay?
    EssayFeature.descendants.map(&:name).include?(self.name)
  end

  def self.fetch_quantity(options={})
    qty = nil
    if options['tutor_time']
      qty = options['tutor_time']
    elsif options['essay_num']
      qty = options['tutor_time']
    end
    qty
  end
end
