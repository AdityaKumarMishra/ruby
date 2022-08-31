class GamsatTextbookFeature < TextbookFeature
  def self.partials
    [
        'pages/partial/gamsat_ready_features/online_textbook',
        'pages/partial/gamsat_ready_features/study_timeline',
        'pages/partial/gamsat_ready_features/essay_writing_guide',
        'pages/partial/gamsat_ready_features/gamsat_strategy'
    ]
  end

  def self.types
    ['GamsatReady']
  end
end