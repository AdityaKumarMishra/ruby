class HscVideoFeature < VideoFeature
  def self.partial
    'pages/partial/hsc_ready_features/course_videos'
  end

  def self.types
    ['HscReady']
  end
end