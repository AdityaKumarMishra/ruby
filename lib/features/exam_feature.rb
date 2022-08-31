class ExamFeature < FeatureType
  def self.url
    'online_exam_attempts_path'
  end

  def self.icon
    'fa fa-tag'
  end

  def self.title
    'Exams'
  end

  def self.model_permissions
    [:online_exam_attempts]
  end

  def self.show_in_sidebar
    true
  end
end