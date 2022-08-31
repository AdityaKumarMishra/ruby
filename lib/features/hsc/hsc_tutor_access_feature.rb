class HscTutorAccessFeature < TutorAccessFeature
  def self.partial
    'pages/partial/hsc_ready_features/online_tutor_access'
  end

  def self.types
    ['HscReady']
  end
end