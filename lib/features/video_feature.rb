class VideoFeature < FeatureType
  def self.title
    'Videos'
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
end