class HscMcqFeature < McqFeature
  def self.partials
    [
        'pages/partial/hsc_ready_features/mcqs',
        'pages/partial/hsc_ready_features/cross_referencing_system',
        'pages/partial/hsc_ready_features/quality_assurance_system'
    ]
  end

  def self.types
    ['HscReady']
  end
end