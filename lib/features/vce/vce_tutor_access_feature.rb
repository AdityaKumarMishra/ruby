class VceTutorAccessFeature < TutorAccessFeature
  def self.partial
    'pages/partial/vce_ready_features/online_tutor_access'
  end

  def self.types
    ['VceReady']
  end
end