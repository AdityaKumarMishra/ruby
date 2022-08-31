class GamsatTextbookHardCopyFeature < FeatureType
  def self.partial
    'pages/partial/gamsat_ready_features/textbook_hard_copy'
  end

  def self.types
    ['GamsatReady']
  end

  def self.title
    'Textbook Hard Copy'
  end
end