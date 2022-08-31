class SurveysFeature < FeatureType
  def self.title
    'Surveys'
  end

  def self.show_in_sidebar
    true
  end

  def self.types
    ['UmatReady', 'GamsatReady']
  end
end