class UmatPrivateTutoringFeature < PrivateTutoringFeature
  def self.partial
    'pages/partial/umat_ready_features/private_tutoring'
  end

  def self.types
    ['UmatReady']
  end
end