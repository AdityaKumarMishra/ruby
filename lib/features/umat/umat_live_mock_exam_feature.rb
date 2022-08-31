class UmatLiveMockExamFeature < LiveExamFeature
  def self.partial
    'pages/partial/umat_ready_features/mock_exam_day'
  end

  def self.types
    ['UmatReady']
  end
end
