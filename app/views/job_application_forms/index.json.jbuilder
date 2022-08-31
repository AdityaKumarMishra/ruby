json.array!(@job_application_forms) do |job_application_form|
  json.extract! job_application_form, :id, :title, :description
  json.url job_application_form_url(job_application_form, format: :json)
end
