class HscAttendanceTutorialsFeature < AttendanceTutorialsFeature
  def self.partials
    [
        'pages/partial/umat_ready_features/interactive_learning',
        'pages/partial/hsc_ready_features/attendance_tutorials'
    ]
  end

  def self.types
    ['HscReady']
  end
end