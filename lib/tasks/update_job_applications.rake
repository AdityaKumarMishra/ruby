namespace :update_job_applications do
  task update_job_applications_form_id: :environment do
    applications  = JobApplication.where('job_application_form_id = ? AND created_at >= ?', 30, "Thu, 11 Jan 2018")
    applications.update_all(job_application_form_id: 43)
  end
end
