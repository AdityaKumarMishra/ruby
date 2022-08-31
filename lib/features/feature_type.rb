class FeatureType
  def self.partials
    [self.try(:partial)].compact
  end

  def self.show_in_sidebar
    false
  end

  def self.types
    []
  end

  def self.all_partials
    self.class.partials << [self.class.partial]
  end

  def self.persisted?
    false
  end

  def self.title
    self.name.titleize
  end

  def self.model_permissions
    []
  end

  def self.default_state
    nil
  end

  # def self.*_attributes=(attributes)
  #
  # end
end