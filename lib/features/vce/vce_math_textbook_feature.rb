class VceMathTextbookFeature < MathTextbookFeature
  def self.partials
    [
        'pages/partial/vce_ready_features/study_timeline',
        'pages/partial/vce_ready_features/strategy',
        'pages/partial/vce_ready_features/math_study_guide'
    ]
  end

  def self.types
    ['VceReady']
  end
end