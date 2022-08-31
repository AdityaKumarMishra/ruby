class TextbookFeature < FeatureType
  def self.url
    'dashboard_textbooks_path'
  end

  def self.icon
    'fa fa-book'
  end

  def self.title
    'Textbooks'
  end

  def self.show_in_sidebar
    true
  end

  def self.model_permissions
    [:textbook]
  end
end