json.array!(@student_class_sessions) do |student_class_session|
  json.extract! student_class_session, :id, :start_time, :end_time, :frequency, :student_classes_id
  json.url student_class_session_url(student_class_session, format: :json)
end
