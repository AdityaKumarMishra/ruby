json.array!(@course_versions) do |course_version|
  json.extract! course_version, :id, :version_number, :date_added, :class_size, :expiry_date, :enrolment_end_added, :students_count
  json.url course_version_url(course_version, format: :json)
end
