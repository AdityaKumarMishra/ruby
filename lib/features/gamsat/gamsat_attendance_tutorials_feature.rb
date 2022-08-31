class GamsatAttendanceTutorialsFeature < AttendanceTutorialsFeature
  def self.partials
    [
        'pages/partial/gamsat_ready_features/interactive_learning',
        'pages/partial/gamsat_ready_features/attendance_tutorials'
    ]
  end

  def self.types
    ['GamsatReady']
  end
end