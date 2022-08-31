class GamsatExamFeature < ExamFeature
  def self.partial
    'pages/partial/gamsat_ready_features/online_exams'
  end

  def self.types
    ['GamsatReady']
  end
end