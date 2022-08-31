class GamsatVideoFeature < VideoFeature
  def self.partial
    'pages/partial/gamsat_ready_features/course_videos'
  end

  def self.types
    ['GamsatReady']
  end
end