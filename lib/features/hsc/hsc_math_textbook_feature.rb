class HscMathTextbookFeature < MathTextbookFeature
  def self.partials
    [
        'pages/partial/hsc_ready_features/study_timeline',
        'pages/partial/hsc_ready_features/strategy',
        'pages/partial/hsc_ready_features/math_study_guide'
    ]
  end

  def self.types
    ['HscReady']
  end
end