class UmatDiagnosticsFeature < DiagnosticsFeature
  def self.partial
    'pages/partial/umat_ready_features/diagnostics_assessment'
  end

  def self.types
    ['UmatReady']
  end
end