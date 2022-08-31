class HscLiveMockExamFeature < LiveExamFeature
  def self.partial
    'pages/partial/hsc_ready_features/mock_exam_day'
  end

  def self.types
    ['HscReady']
  end
end
