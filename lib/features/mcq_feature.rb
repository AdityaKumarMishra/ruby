class McqFeature < FeatureType
  def self.url
    'new_exercise_path'
  end

  def self.icon
    'fa fa-plus-square'
  end

  def self.title
    'MCQs'
  end

  def self.show_in_sidebar
    true
  end

  def self.model_permissions
    [:mcq_stem]
  end
end