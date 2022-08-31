class HscExamFeature < ExamFeature
  def self.partial
    'pages/partial/hsc_ready_features/online_exams'
  end

  def self.types
    ['HscReady']
  end
end