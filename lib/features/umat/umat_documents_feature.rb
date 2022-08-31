class UmatDocumentsFeature < DocumentsFeature
  def self.partial
    'pages/partial/umat_ready_features/documents'
  end

  def self.types
    ['UmatReady']
  end
end