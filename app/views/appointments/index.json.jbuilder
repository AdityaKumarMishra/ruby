json.array!(appointments) do |appointment|
  json.extract! appointment, :id, :student_id, :tutor_availability_id
  json.url apoitment_url(appointment, format: :json)
end
