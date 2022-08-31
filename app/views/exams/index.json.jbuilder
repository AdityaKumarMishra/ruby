json.array!(@exams) do |exam|
  json.extract! exam, :id, :date_started, :date_finished, :type
  json.url exam_url(exam, format: :json)
end
