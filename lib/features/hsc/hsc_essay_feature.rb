class HscEssayFeature < EssayFeature
  def self.partial
    'pages/partial/hsc_ready_features/marked_essays'
  end

  def self.types
    ['HscReady']
  end
end