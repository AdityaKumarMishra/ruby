class VceDiagnosticsFeature < DiagnosticsFeature
  def self.partial
    'pages/partial/vce_ready_features/diagnostics_assessment'
  end

  def self.types
    ['VceReady']
  end
end