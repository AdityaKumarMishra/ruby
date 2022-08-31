json.array!(@courses) do |course|
  json.extract! course, :id, :name, :class_size, :expiry_date, :enrolment_end_date, :product_version_id
  json.url course_url(course, format: :json)
end
