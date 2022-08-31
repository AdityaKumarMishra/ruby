class DiagnosticsFeature < FeatureType
  def self.url
    'diagnostic_test_attempts_path'
  end

  def self.icon
    'fa fa-tag'
  end

  def self.title
    'Diagnostics Assessment'
  end

  def self.model_permissions
    [:diagnostic_test_attempts]
  end

  def self.show_in_sidebar
    true
  end
end