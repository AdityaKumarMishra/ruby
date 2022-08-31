class PrivateTutoringFeature < FeatureType
  def self.icon
    'fa fa-calendar-plus-o'
  end

  def self.url
    'dashboard_book_tutor_path'
  end

  def self.title
    'Book Tutor'
  end

  def self.model_permissions
    [:tutor_availability]
  end

  def self.show_in_sidebar
    true
  end
end