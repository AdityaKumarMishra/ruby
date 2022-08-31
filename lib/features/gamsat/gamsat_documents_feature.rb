class GamsatDocumentsFeature < DocumentsFeature
  def self.partial
    'pages/partial/gamsat_ready_features/documents'
  end

  def self.types
    ['GamsatReady']
  end
end