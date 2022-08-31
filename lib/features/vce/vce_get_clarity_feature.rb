class VceGetClarityFeature < GetClarityFeature
  def self.partial
    'pages/partial/vce_ready_features/get_clarity'
  end

  def self.types
    ['VceReady']
  end
end