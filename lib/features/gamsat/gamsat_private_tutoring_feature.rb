class GamsatPrivateTutoringFeature < PrivateTutoringFeature
  def self.partial
    'pages/partial/gamsat_ready_features/private_tutoring'
  end

  def self.types
    ['GamsatReady']
  end
end