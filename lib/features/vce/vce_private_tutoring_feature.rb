class VcePrivateTutoringFeature < PrivateTutoringFeature
  def self.partial
    'pages/partial/vce_ready_features/private_tutoring'
  end

  def self.types
    ['VceReady']
  end
end