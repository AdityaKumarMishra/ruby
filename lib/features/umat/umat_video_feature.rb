class UmatVideoFeature < VideoFeature
  def self.partial
    'pages/partial/umat_ready_features/course_videos'
  end

  def self.types
    ['UmatReady']
  end
end