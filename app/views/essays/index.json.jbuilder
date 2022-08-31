json.array!(@essays) do |essay|
  json.extract! essay, :id, :title, :question, :date_added, :expiration_date, :tutor_id, :student_id
  json.url essay_url(essay, format: :json)
end
