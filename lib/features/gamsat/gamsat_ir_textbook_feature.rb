class GamsatIrTextbookFeature < FeatureType
  def self.partial
    'pages/partial/gamsat_ready_features/course_ir_textbook'
  end

  def self.types
    ['GamsatReady']
  end

  def self.title
    'InterviewReady-Textbook'
  end

  def self.icon
    'fa fa-book'
  end
end