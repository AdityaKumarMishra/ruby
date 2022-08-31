class GamsatDiagnosticsFeature < DiagnosticsFeature
  def self.partial
    'pages/partial/gamsat_ready_features/diagnostics_assessment'
  end

  def self.name
    'Diagnostics Assessment'
  end

  def self.types
    ['GamsatReady']
  end
end
