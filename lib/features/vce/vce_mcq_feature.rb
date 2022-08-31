class VceMcqFeature < McqFeature
  def self.partials
    [
        'pages/partial/vce_ready_features/mcqs',
        'pages/partial/vce_ready_features/cross_referencing_system',
        'pages/partial/vce_ready_features/quality_assurance_system'
    ]
  end

  def self.types
    ['VceReady']
  end
end