class UmatExamFeature < ExamFeature
  def self.partial
    'pages/partial/umat_ready_features/online_exams'
  end

  def self.types
    ['UmatReady']
  end
end