class GamsatMcqFeature < McqFeature
  def self.partials
    [
        'pages/partial/gamsat_ready_features/mcqs',
        'pages/partial/gamsat_ready_features/cross_referencing_system',
        'pages/partial/gamsat_ready_features/quality_assurance_system'
    ]
  end

  def self.types
    ['GamsatReady']
  end
end