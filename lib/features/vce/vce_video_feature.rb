class VceVideoFeature < VideoFeature
  def self.partial
    'pages/partial/vce_ready_features/course_videos'
  end

  def self.types
    ['VceReady']
  end
end