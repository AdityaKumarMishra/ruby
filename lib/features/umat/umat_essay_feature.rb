class UmatEssayFeature < EssayFeature
  def self.partial
    'pages/partial/umat_ready_features/marked_essays'
  end

  def self.types
    ['UmatReady']
  end
end