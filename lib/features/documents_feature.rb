class DocumentsFeature < FeatureType
  def self.title
    'Documents'
  end

  def self.icon
    'fa fa-folder'
  end

  def self.url
    'documents_path'
  end

  def self.show_in_sidebar
    true
  end

  def self.model_permissions
    [:document]
  end

end