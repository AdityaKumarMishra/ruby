class GamsatTutorAccessFeature < TutorAccessFeature
  def self.partials
    [
        'pages/partial/gamsat_ready_features/online_tutor_access',
        'pages/partial/gamsat_ready_features/extra_essays',
        'pages/partial/gamsat_ready_features/marked_essays'
    ]
  end

  def self.types
    ['GamsatReady']
  end
end