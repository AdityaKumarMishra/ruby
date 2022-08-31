class UmatMcqFeature < McqFeature
  def self.partials
    [
        'pages/partial/umat_ready_features/mcqs',
        'pages/partial/umat_ready_features/cross_referencing_system',
        'pages/partial/umat_ready_features/quality_assurance_system'
    ]
  end

  def self.types
    ['UmatReady']
  end
end