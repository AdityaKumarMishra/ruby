class GamsatGetClarityFeature < GetClarityFeature
  def self.partial
    'pages/partial/gamsat_ready_features/get_clarity'
  end

  def self.types
    ['GamsatReady']
  end
end