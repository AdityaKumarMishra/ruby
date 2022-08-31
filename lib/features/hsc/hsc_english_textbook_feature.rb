class HscEnglishTextbookFeature < EnglishTextbookFeature
  def self.partials
    [
        'pages/partial/hsc_ready_features/study_timeline',
        'pages/partial/hsc_ready_features/strategy',
        'pages/partial/hsc_ready_features/essay_writing',
        'pages/partial/hsc_ready_features/english_study_guide'
    ]
  end

  def self.types
    ['HscReady']
  end
end