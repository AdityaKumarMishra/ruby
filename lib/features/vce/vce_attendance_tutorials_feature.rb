class VceAttendanceTutorialsFeature < AttendanceTutorialsFeature
  def self.partials
    [
        'pages/partial/vce_ready_features/interactive_learning',
        'pages/partial/vce_ready_features/attendance_tutorials'
    ]
  end

  def self.types
    ['VceReady']
  end
end