json.array!(@enrolments) do |enrolment|
  json.extract! enrolment, :id, :user_id, :course_id
  json.url enrolment_url(enrolment, format: :json)
end
