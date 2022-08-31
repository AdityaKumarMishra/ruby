class AdditionalTutoringFeature < FeatureType
  @title= 'Purchase Additional Tutoring Sessions'

  def self.show_in_sidebar
    true
  end

  def self.types
    ['UmatReady', 'GamsatReady']
  end
end