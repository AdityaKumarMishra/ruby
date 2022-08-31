class GamsatEssayFeature < EssayFeature
  def self.partial
    'pages/partial/gamsat_ready_features/marked_essays'
  end

  def self.types
    ['GamsatReady']
  end
end