class HscDiagnosticsFeature < DiagnosticsFeature
  def self.partial
    'pages/partial/hsc_ready_features/diagnostics_assessment'
  end

  def self.types
    ['HscReady']
  end
end