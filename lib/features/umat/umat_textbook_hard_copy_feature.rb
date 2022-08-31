class UmatTextbookHardCopyFeature < FeatureType
  def self.partial
    'pages/partial/umat_ready_features/textbook_hard_copy'
  end

  def self.types
    ['UmatReady']
  end

  def self.title
    'Textbook Hard Copy'
  end
end