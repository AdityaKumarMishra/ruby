class EssayFeature < FeatureType
  def self.url
    'essay_responses_path'
  end

  def self.icon
    'fa fa-pencil'
  end

  def self.title
    'My essays'
  end

  def self.show_in_sidebar
    true
  end
end