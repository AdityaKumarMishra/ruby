class UmatTextbookFeature < TextbookFeature
  def self.partials
    [
        'pages/partial/umat_ready_features/online_textbook',
        'pages/partial/umat_ready_features/study_timeline',
        'pages/partial/umat_ready_features/umat_strategy'
    ]
  end

  def self.types
    ['UmatReady']
  end
end