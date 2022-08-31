json.array!(@online_exams) do |_exam|
  json.extract! online_exam, :id, :title, :instruction, :type
  json.url online_exam_url(online_exam, format: :json)
end
