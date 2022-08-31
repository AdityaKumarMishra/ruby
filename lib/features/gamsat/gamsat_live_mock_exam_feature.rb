class GamsatLiveMockExamFeature < LiveExamFeature
  def self.partial
    'pages/partial/gamsat_ready_features/mock_exam_day'
  end

  def self.types
    ['GamsatReady']
  end
end
