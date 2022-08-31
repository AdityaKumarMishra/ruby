class UmatTutorAccessFeature < TutorAccessFeature
  def self.partial
    'pages/partial/umat_ready_features/online_tutor_access'
  end

  def self.types
    ['UmatReady']
  end
end