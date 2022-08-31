json.array!(@job_applications) do |job_application|
  json.extract! job_application, :id, :name, :last_name, :phone_number, :email, :job_application_form_id
  json.url job_application_url(job_application, format: :json)
end
