class VceEssayFeature < EssayFeature
  def self.partial
    'pages/partial/vce_ready_features/marked_essays'
  end

  def self.types
    ['VceReady']
  end
end