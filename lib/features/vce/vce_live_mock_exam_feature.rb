class VceLiveMockExamFeature < LiveExamFeature
  def self.partial
    'pages/partial/vce_ready_features/mock_exam_day'
  end

  def self.types
    ['VceReady']
  end
end
