class HscTextbookFeature < TextbookFeature
  def self.partials
    [
        'pages/partial/hsc_ready_features/study_timeline',
        'pages/partial/hsc_ready_features/strategy',
    ]
  end

  def self.types
    ['HscReady']
  end
end