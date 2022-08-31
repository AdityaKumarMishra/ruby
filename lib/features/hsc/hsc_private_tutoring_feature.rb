class HscPrivateTutoringFeature < PrivateTutoringFeature
  def self.partial
    'pages/partial/hsc_ready_features/private_tutoring'
  end

  def self.types
    ['HscReady']
  end
end