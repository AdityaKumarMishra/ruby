class VceExamFeature < ExamFeature
  def self.partial
    'pages/partial/vce_ready_features/online_exams'
  end

  def self.types
    ['VceReady']
  end
end