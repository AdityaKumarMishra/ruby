class GamsatIrVideoFeature < FeatureType
  def self.partial
    'pages/partial/gamsat_ready_features/course_ir_videos'
  end

  def self.types
    ['GamsatReady']
  end

  def self.title
    'InterviewReady-Videos'
  end

  def self.url
    'vods_path'
  end

  def self.icon
    'fa fa-video-camera'
  end

  def self.model_permissions
    [:vod]
  end

  def self.show_in_sidebar
    true
  end

  def self.default_state
    :disabled
  end
end